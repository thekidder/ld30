using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class NoiseField : MonoBehaviour {
	public GameObject player;
	
	public int width;
	public int height;
	
	public float ambientNoise;
	public float noiseCenter;
	
	public float noiseFrequency;
	
	public float playerVision;
	
	private float lastNoiseGen = 0f;
	private List<Beacon> beacons = new List<Beacon>();
	private List<float> noise;
	private float visionConstant;

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
		
		noise = new List<float>(width * height);
		for(int i = 0; i < width * height; ++i) {
			noise.Add(0f);
		}
		
		visionConstant = PlayerController.SIZE * PlayerController.SIZE * playerVision * playerVision;
	}
	
	// Update is called once per frame
	void Update () {
		for(int i = 0; i < width; ++i) {
			for(int j = 0; j < height; ++j) {
				GameObject point = gameObject.transform.GetChild(j + i * height).gameObject;
				Vector2 dist = (Vector2)transform.position
					+ new Vector2(i * PlayerController.SIZE, j * PlayerController.SIZE)
					- (Vector2)player.transform.position;
				float alpha = Mathf.Clamp(dist.sqrMagnitude, 0f, visionConstant) / visionConstant;
				Color c = point.GetComponent<SpriteRenderer>().color;
				c.a = Mathf.Max (alpha, 5f * noise[j + i * height]);
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
				float noiseRange = noise[j + i * height];
				float currentNoise = Random.Range(-noiseRange / 2f, noiseRange / 2f) + noiseCenter;
				point.GetComponent<SpriteRenderer>().color = new Color(
					currentNoise, currentNoise, currentNoise + 0.05f, point.GetComponent<SpriteRenderer>().color.a);
            }
		}
	}
	
	void FixedUpdate() {
		for(int i = 0; i < width; ++i) {
			for(int j = 0; j < height; ++j) {
				Vector2 pos = (Vector2)transform.position + new Vector2(i * PlayerController.SIZE, j * PlayerController.SIZE);
				
				float totalNoise = ambientNoise;
				foreach(Beacon b in beacons) {
					totalNoise += b.collectNoise(pos);
				}
				
				noise[j + i * height] = totalNoise;
			}
		}
	}
	
	public void AddBeacon(Beacon beacon) {
		beacons.Add(beacon);
	}
}
