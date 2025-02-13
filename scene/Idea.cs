using Godot;
using System;

public partial class Idea : Node3D
{
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        // Initialize any variables or game state here.
        // This method is called once when the node is added to the scene.
        GD.Print("Idea node is ready.");
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        // Implement any per-frame logic here.
        // Use 'delta' to make frame-rate independent calculations.
    }
}
