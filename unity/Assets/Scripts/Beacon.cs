using UnityEngine;
using System.Collections;

public abstract class Beacon : MonoBehaviour {
	public NoiseField noise;
	
	public bool activated;
	
	protected virtual void Start() {
		activated = false;
		noise.AddBeacon(this);
	}

	public abstract float collectNoise(Vector2 pos);
	public virtual void Activate() { activated = true; }
}
