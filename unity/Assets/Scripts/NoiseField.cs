using UnityEngine;
using System.Collections;

public class NoiseField : MonoBehaviour {
	public GameObject player;
	
	public int width;
	public int height;
	
	public float noiseFrequency;
	
	private float lastNoiseGen = 0f;

	// Use this for initialization
	void Start () {
		GameObject pixel = (GameObject)Resources.Load("Prefabs/Pixel");
		
		for(int i = 0; i < width; ++i) {
			for(int j = 0; j < height; ++j) {
				GameObject go = (GameObject)GameObject.Instantiate(pixel);
				go.name = string.Format("noise_{0}_{1}", i, j);
				go.transform.parent = this.transform;
				go.transform.localPosition = new Vector3(PlayerController.SIZE * i, PlayerController.SIZE * j, 0);
            }
		}
	}
	
	// Update is called once per frame
	void Update () {
		for(int i = 0; i < width; ++i) {
			for(int j = 0; j < height; ++j) {
				GameObject point = gameObject.transform.GetChild(j + i * height).gameObject;
				Vector2 dist = transform.position + new Vector3(i * PlayerController.SIZE, j * PlayerController.SIZE, 0f) - player.transform.position;
                float alpha = Mathf.Clamp(dist.sqrMagnitude, 0f, 102400f) / 102400f;
				Color c = point.GetComponent<SpriteRenderer>().color;
				c.a = alpha;
				point.GetComponent<SpriteRenderer>().color = c;
			}
		}
	
		if(Time.time - lastNoiseGen < noiseFrequency) {
			return;
		}
		lastNoiseGen = Time.time;
		for(int i = 0; i < width; ++i) {
			for(int j = 0; j < height; ++j) {
				GameObject point = gameObject.transform.GetChild(j + i * height).gameObject;
				float noise = Random.Range(0.4f, 0.6f);
				point.GetComponent<SpriteRenderer>().color = new Color(noise, noise, noise + 0.05f, point.GetComponent<SpriteRenderer>().color.a);
            }
		}
	}
}
