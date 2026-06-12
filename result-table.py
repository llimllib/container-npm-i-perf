import json, math

with open("results.json") as f:
    data = json.load(f)

results = data["results"]

# Find the native result to use as baseline
baseline = next((r for r in results if "native" in r["command"].lower()), results[0])
base_mean = baseline["mean"]
base_stddev = baseline["stddev"]

# Sort by mean time
results.sort(key=lambda r: r["mean"])

def short_name(cmd):
    cmd = cmd.lower()
    if "native" in cmd: return "native"
    if "orbstack" in cmd: return "orbstack"
    if "apple" in cmd or "container" in cmd and "docker" not in cmd: return "apple container"
    if "docker desktop" in cmd: return "docker desktop"
    if "colima" in cmd: return "colima"
    return cmd.split("(")[0].strip()

print()
print(f"| {'Test':<17} | {'mean':>6} | {'stdev':>6} | {'min':>7} | {'max':>7} | {'ratio':<11} |")
print(f"| {':' + '-'*16} | {':' + '-'*5} | {':' + '-'*5} | {':' + '-'*6} | {':' + '-'*6} | {':' + '-'*10} |")

for r in results:
    name = short_name(r["command"])
    mean = r["mean"]
    stddev = r["stddev"]
    mn = r["min"]
    mx = r["max"]

    if r is baseline:
        ratio_str = "1"
    else:
        ratio = mean / base_mean
        ratio_err = ratio * math.sqrt((stddev/mean)**2 + (base_stddev/base_mean)**2)
        ratio_str = f"{ratio:.2f} \u00b1 {ratio_err:.2f}"

    print(f"| {name:<17} | {mean:6.3f} | {stddev:6.3f} | {mn:7.3f} | {mx:7.3f} | {ratio_str:<11} |")

print()
