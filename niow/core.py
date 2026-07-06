class Niow:
    """Core logic for the niow tool (minimal scaffold)."""

    def __init__(self, name: str = "niow"):
        self.name = name

    def greet(self) -> str:
        """Return a simple greeting message used by the CLI and tests."""
        return f"Niow tool initialized: {self.name}"
