library renderer;

import 'dart:html';
import 'dart:math';

import 'package:three/three.dart';
import 'package:vector_math/vector_math.dart';

import 'canvas_color.dart';

const double SIZE = 16.0;

class Pixel {
  Geometry _geometry;
  MeshBasicMaterial _material;
  Mesh _mesh;
  
  int _z;
  
  Pixel(Point<int> pos, int this._z, CanvasColor color, [bool transparent = false]) {
    _geometry = new Geometry();
    _geometry.vertices.add(new Vector3(0.0, SIZE, 0.0));
    _geometry.vertices.add(new Vector3(SIZE, SIZE, 0.0));
    _geometry.vertices.add(new Vector3(SIZE, 0.0, 0.0));
    _geometry.vertices.add(new Vector3(0.0, 0.0, 0.0));
    _geometry.faces.add(new Face4(0, 1, 2, 3));
    
    _material = new MeshBasicMaterial(
        color:color.hex(),
        side:DoubleSide,
        transparent: transparent,
        opacity: 0.5);
    
    _mesh = new Mesh(_geometry, _material);
    this.pos = pos;
  }
  
  void set pos(Point<int> pos) {
    _mesh.position = new Vector3(pos.x * SIZE, pos.y * SIZE, -_z.toDouble());
  }
  
  void set color(CanvasColor color) {
    _material
        ..color = color.threeColor()
        ..opacity = color.a;
  }
  
  void addToScene(Scene scene) {
    scene.add(_mesh);
  }
}

class Renderer {
  OrthographicCamera _camera;
  Scene _scene;
  WebGLRenderer _renderer;
  
  Renderer() {
    _camera = new OrthographicCamera(
        0.0, window.innerWidth.toDouble(),
        0.0, window.innerHeight.toDouble(),
        0.1, 1000.0);
    
    _scene = new Scene();
    
    HtmlElement container = new Element.tag('div');
    document.body.nodes.add(container);
    
    _renderer = new WebGLRenderer(clearColorHex: 0x000000);
    _renderer.setSize(window.innerWidth, window.innerHeight);
    container.children.add(_renderer.domElement);
  }
  
  void addPixel(Pixel p) {
    p.addToScene(_scene);
  }
  
  void render() {
    _renderer.render(_scene, _camera);
  }
}