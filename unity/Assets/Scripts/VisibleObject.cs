using UnityEngine;
using System.Collections;

public class VisibleObject : MonoBehaviour {
	public float visibility;
	public float magnitude = 1.0f;

	public NoiseField noise;
	
	protected virtual void Start() {
		noise.AddVisibleObject(this);
	}
}
