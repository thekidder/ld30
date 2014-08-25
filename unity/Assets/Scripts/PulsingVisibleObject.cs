using UnityEngine;
using System.Collections;

public class PulsingVisibleObject : VisibleObject {
	public Vector2 visibilityRange;
	public Vector2 magnitudeRange;
	
	public float decay;
	public float growth;
	
	private bool growing = true;

	// Use this for initialization
	protected override void Start () {
		base.Start();
		
		visibility = visibilityRange.x;
		magnitude = magnitudeRange.x;
	}
	
	// Update is called once per frame
	void Update () {
		Beacon beacon = GetComponent<Beacon>();
		if(beacon && beacon.activated) {
			magnitude = 0f;
			visibility = 0f;
			return;
		}

		if(growing) {
			visibility += Time.deltaTime * growth;
			if(visibility >= visibilityRange.y) {
				visibility = visibilityRange.y;
				growing = false;
			}
		} else {
			visibility -= Time.deltaTime * decay;
			
			if(visibility <= visibilityRange.x) {
				visibility = visibilityRange.x;
				growing = true;
			}
		}
		magnitude = Mathf.Lerp(magnitudeRange.x, magnitudeRange.y, Mathf.InverseLerp(visibilityRange.x, visibilityRange.y, visibility));
		Color c = GetComponent<SpriteRenderer>().color;
		c.a = magnitude * 2f;
		GetComponent<SpriteRenderer>().color = c;
	}
}
