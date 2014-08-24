using UnityEngine;
using System.Collections;

public class BurstyBeacon : Beacon {
	public Transform source;

	public float radius;
	public float decay;
	public float growth;
	public float effect;
	
	private float strength = PlayerController.SIZE;
	private bool growing = true;
	
	// Use this for initialization
	override protected void Start () {
		base.Start();
	}
	
	void FixedUpdate() {
		if(activated) { return; }
		if(growing) {
			strength += Time.fixedDeltaTime * growth * PlayerController.SIZE;
			if(strength >= radius * PlayerController.SIZE) {
				strength = radius * PlayerController.SIZE;
				growing = false;
			}
		} else {
			strength -= Time.fixedDeltaTime * decay * PlayerController.SIZE;
			
			if(strength <= PlayerController.SIZE) {
				strength = PlayerController.SIZE;
				growing = true;
			}
		}
	}
	
	public override float collectNoise(Vector2 pos) {
		float dist = (pos - (Vector2)source.position).magnitude;
		
		if(dist < strength) {
			return effect;
		} else {
			return 0f;
		}
	}
	
	public override void Activate() {
		base.Activate();
		strength = 0f;
		GetComponent<SpriteRenderer>().enabled = false;
	}
}
