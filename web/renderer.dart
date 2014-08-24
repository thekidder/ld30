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
    _geometry.vertices.add(new Vector3(0.0, 1.0, 0.0));
    _geometry.vertices.add(new Vector3(1.0, 1.0, 0.0));
    _geometry.vertices.add(new Vector3(1.0, 0.0, 0.0));
    _geometry.vertices.add(new Vector3(0.0, 0.0, 0.0));
    _geometry.faces.add(new Face4(0, 1, 2, 3));
    _geometry.isDynamic = true;

    _material = new MeshBasicMaterial(
        color:color.hex(),
        side:DoubleSide,
        transparent: transparent,
        opacity: 0.5);
    
    _mesh = new Mesh(_geometry, _material);
    _mesh.isDynamic = true;
    this.pos = pos;
  }
  
  void set size(int size) {
    _geometry.vertices.clear();
    _geometry.vertices.add(new Vector3(0.0, size.toDouble(), 0.0));
    _geometry.vertices.add(new Vector3(size.toDouble(), size.toDouble(), 0.0));
    _geometry.vertices.add(new Vector3(size.toDouble(), 0.0, 0.0));
    _geometry.vertices.add(new Vector3(0.0, 0.0, 0.0));
    
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
  
  int size = 16;
  int width, height;
  
  List<Object> _all;
  
  Renderer(this.width, this.height) {
    _camera = new OrthographicCamera(
        0.0, window.innerWidth.toDouble(),
        0.0, window.innerHeight.toDouble(),
        0.1, 1000.0);
    
    _scene = new Scene();
    
    HtmlElement container = new Element.tag('div');
    document.body.nodes.add(container);
    
    _renderer = new WebGLRenderer(clearColorHex: 0xDCDCE6);
    _renderer.setSize(window.innerWidth, window.innerHeight);
    container.children.add(_renderer.domElement);
    
    _all = new List();
    
    window.onResize.listen(this.onWindowResize);
    onWindowResize(null);
  }
  
  void addPixel(Pixel p) {
    p.size = size;
    p.addToScene(_scene);
    _all.add(p);
  }
  
  void onWindowResize(event) {
    _camera.updateProjectionMatrix();

    size = window.innerWidth ~/ width;
    if(window.innerHeight ~/ height < size) {
      size = window.innerHeight ~/ height;
    }
    
    _camera..right = (size * width).toDouble()
           ..bottom = (size * height).toDouble();
    
    _renderer.setSize(size * width, size * height);
    _renderer.domElement.style.position = 'absolute';
    _renderer.domElement.style.left = ((window.innerWidth - size * width) ~/ 2).toString() + 'px';
    _renderer.domElement.style.top = ((window.innerHeight - size * height) ~/ 2).toString() + 'px';
    
    _all.forEach((obj) {
      obj.size = size;
    });
  }
  
  void render() {
    _renderer.render(_scene, _camera);
  }
}