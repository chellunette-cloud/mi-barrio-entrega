[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$FrontendUrl,

    [Parameter(Mandatory = $true)]
    [string]$ApiUrl,

    [Parameter(Mandatory = $true)]
    [string]$BackendUrl,

    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

if (-not (Test-Path '.git')) {
    throw "No se encontró un repositorio Git en $root. Ejecuta este script desde mi-barrio-entrega."
}

$null = git rev-parse --verify HEAD 2>$null
if ($LASTEXITCODE -ne 0) {
    throw 'El repositorio principal no tiene ningún commit. Crea el commit inicial antes de añadir submódulos.'
}

function Assert-RemoteUrl {
    param([string]$Name, [string]$Url)

    if ([string]::IsNullOrWhiteSpace($Url)) {
        throw "$Name no puede estar vacío."
    }
    if ($Url -notmatch '^(https://|git@)') {
        throw "$Name debe usar https:// o git@. Valor recibido: $Url"
    }
    if ($Url -match '<|>|USUARIO|URL_REAL|example\.com') {
        throw "$Name contiene un marcador de plantilla. Usa la URL real del remoto."
    }
}

Assert-RemoteUrl -Name 'FrontendUrl' -Url $FrontendUrl
Assert-RemoteUrl -Name 'ApiUrl' -Url $ApiUrl
Assert-RemoteUrl -Name 'BackendUrl' -Url $BackendUrl

$modules = @(
    @{ Name = 'mi-barrio-frontend'; Url = $FrontendUrl },
    @{ Name = 'mi-barrio-api'; Url = $ApiUrl },
    @{ Name = 'mi-barrio-backend'; Url = $BackendUrl }
)

foreach ($module in $modules) {
    if (Test-Path $module.Name) {
        throw "La ruta '$($module.Name)' ya existe. Revisa si el submódulo ya está configurado o mueve ese directorio antes de continuar."
    }
}

if ($DryRun) {
    Write-Host 'Modo DryRun: no se modificará el repositorio.' -ForegroundColor Yellow
    foreach ($module in $modules) {
        Write-Host "git submodule add $($module.Url) $($module.Name)"
    }
    return
}

foreach ($module in $modules) {
    Write-Host "Comprobando acceso a $($module.Name)..." -ForegroundColor Cyan
    $null = git ls-remote $module.Url 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "No se pudo acceder a $($module.Url). Verifica la URL, la autenticación y que el repositorio tenga al menos un commit."
    }
}

foreach ($module in $modules) {
    Write-Host "Añadiendo submódulo $($module.Name)..." -ForegroundColor Cyan
    git submodule add $module.Url $module.Name
    if ($LASTEXITCODE -ne 0) {
        throw "Falló 'git submodule add' para $($module.Name)."
    }
}

Write-Host ''
Write-Host 'Submódulos añadidos. Revisa .gitmodules y el estado antes de confirmar:' -ForegroundColor Green
git submodule status
git status --short
Write-Host ''
Write-Host 'Siguiente paso: revisar los commits fijados, hacer commit y push del repositorio principal.'
