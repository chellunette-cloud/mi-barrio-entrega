"""Filtra manzanas de estrato cuyo centroide cae dentro del polígono del barrio.

Uso:
    python filtrar_estrato.py <barrio.geojson> <estrato_bbox.geojson> <salida.geojson>
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

from shapely.geometry import shape


def load_features(path: Path) -> list[dict]:
    with path.open(encoding="utf-8-sig") as handle:
        data = json.load(handle)
    return data.get("features", [])


def main(barrio_path: Path, bbox_path: Path, out_path: Path) -> int:
    barrio_features = load_features(barrio_path)
    if not barrio_features:
        print("El archivo del barrio no contiene features.", file=sys.stderr)
        return 1

    barrio = shape(barrio_features[0]["geometry"])
    bbox_features = load_features(bbox_path)
    selected = []

    for feature in bbox_features:
        geometry = feature.get("geometry")
        if not geometry:
            continue
        if barrio.contains(shape(geometry).centroid):
            selected.append(feature)

    output = {
        "type": "FeatureCollection",
        "metadata": {
            "capa": "Manzanas de estrato - IDECA/UAECD",
            "url": (
                "https://serviciosgis.catastrobogota.gov.co/arcgis/rest/services/"
                "ordenamientoterritorial/estratificacion/MapServer/1"
            ),
            "consultado": "2026-11-15",
            "metodo": (
                "Consulta por bbox del barrio +0.006 grados; se conservan las "
                "manzanas cuyo centroide cae dentro del poligono oficial"
            ),
            "total_bbox": len(bbox_features),
            "total_dentro": len(selected),
        },
        "features": selected,
    }

    with out_path.open("w", encoding="utf-8") as handle:
        json.dump(output, handle, ensure_ascii=False, indent=2)

    print(f"bbox={len(bbox_features)} dentro={len(selected)} salida={out_path}")
    return 0


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print(__doc__, file=sys.stderr)
        raise SystemExit(2)
    raise SystemExit(main(Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3])))
