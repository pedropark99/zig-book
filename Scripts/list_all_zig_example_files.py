import os
from pathlib import Path
import re

files = list()
zig_files = Path("ZigExamples").glob('**/*.zig')

for path in zig_files:
    if re.search(r".zig-cache|build_and_run_all_examples", str(path)):
        continue

    files.append(f'"{path}"')

print(",\n".join(files))
