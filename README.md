# PyTestFlow & LabVIEW Integration Project

## Overview
This project aims to provide a powerful, free, and lightweight test sequencer infrastructure by combining the flexibility of **PyTestFlow** with the measurement and hardware control capabilities of **LabVIEW**. 

By utilizing the **JKI Python Bridge for LabVIEW**, developers can easily write custom test sequences in Python that seamlessly execute LabVIEW code. This allows for modern UI reporting and sequencing via PyTestFlow, while maintaining the robust execution of LabVIEW VIs in the background.

> **Note:** For a quick visual overview of PyTestFlow's core concepts, please refer to the attached `pytestflow.pdf` file in this repository.

## Prerequisites
Before running the Python test sequences, you need to ensure the following prerequisites are met:
1. **Python 3.10+**: You must have Python 3.10 or newer installed on your system and added to your system's PATH.
2. **Install the LabVIEW Toolkit**: Download and install the [JKI LabVIEW Python Server](https://github.com/JKISoftware/jki-labview-python-server) via VIPM (VI Package Manager).
3. **Run the LabVIEW Server**: Open LabVIEW and run the **"Python Bridge Example"** server application. This server must be actively running in the background to listen for commands sent from Python.

## Automated 1-Click Installation
You do **not** need to manually configure Python dependencies. A fully automated installation script is provided.

1. Double-click the `install.bat` file.
2. The script will automatically:
   - Clone the PyTestFlow repository.
   - Apply necessary Python 3.10 syntax compatibility patches.
   - Create a dedicated virtual environment (`.venv`).
   - Install **PyTestFlow** and the **jki-python-bridge-for-labview** dependencies.
   - Initialize the PyTestFlow workspace.

## Usage
Once the installation is complete and the LabVIEW server is running:

1. Double-click the `run_pytestflow.bat` file.
2. This will activate the virtual environment and automatically launch the PyTestFlow UI in your web browser.
3. You can now execute your custom sequence files. 

### Writing Custom Sequences
In your sequence files, you can import the LabVIEW bridge and call LabVIEW functions directly from Python. 

**Example snippet:**
```python
from pytestflow.core.sequence import TestSequence
from pytestflow.steps.numeric_limit import numeric_limit_step
from pytestflow.steps.pass_fail import pass_fail_step
from jki_python_bridge_for_labview import labview as lv


def get_vcore_from_labview():
    try:
        lv.connect()
        result = lv.example.add(1, 2)
        lv.disconnect()
        return result
    except Exception as e:
        return e

@numeric_limit_step(name="measure_vcore", limit=(1.0, 1.3), mode="between")
def measure_vcore():
    return get_vcore_from_labview()

@pass_fail_step(name="functional_check")
def functional_check():
    return True


def main_sequence() -> TestSequence:
    return TestSequence(
        name="BasicSequence",
        setup_steps=[],
        main_steps=[measure_vcore, functional_check],
        cleanup_steps=[],
    )


PROCESS_HOOKS = {
    "main_sequence": main_sequence,
}