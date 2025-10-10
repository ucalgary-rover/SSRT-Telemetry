import math

# worst case-scenario, we use this website: https://latlongdata.com/distance-calculator/


def haversine(lat1, lon1, lat2, lon2):
    R = 6371  # Earth radius in km
    phi1, phi2 = math.radians(lat1), math.radians(lat2)
    dphi = math.radians(lat2 - lat1)
    dlambda = math.radians(lon2 - lon1)
    a = math.sin(dphi/2)**2 + math.cos(phi1)*math.cos(phi2)*math.sin(dlambda/2)**2
    return 2 * R * math.asin(math.sqrt(a))

points = []
with open('../saves/2025-08-07T20,22,39Z.txt') as f:
    next(f)  # skip header
    for line in f:
        coord = line.split(' - ')[0]
        lat, lon = map(float, coord.split(','))
        points.append((lat, lon))

start = points[0]
output_lines = []
for i, (lat, lon) in enumerate(points[1:], 1):
    dist = haversine(start[0], start[1], lat, lon)
    output_lines.append(f"Point {i}: ({lat}, {lon}) Distance from start ({start[0]}, {start[1]}): {dist:.3f} km\n")

with open('distances_output.txt', 'w') as f:
    f.writelines(output_lines)
