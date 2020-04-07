from pathlib import Path
from vunit import VUnit

VU = VUnit.from_argv()
VU.add_verification_components()

SRC_PATH = Path(__file__).parent / "src"

VU.add_library("lib").add_source_files(
    [SRC_PATH / "*.vhdl", SRC_PATH / "test" / "*.vhdl"]
)

VU.main()
