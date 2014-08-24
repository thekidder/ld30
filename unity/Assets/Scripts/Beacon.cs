using UnityEngine;
using System.Collections;

public abstract class Beacon : MonoBehaviour {
	public NoiseField noise;
	
	protected virtual void Start() {
		noise.AddBeacon(this);
	}

	public abstract float collectNoise(Vector2 pos);
}
