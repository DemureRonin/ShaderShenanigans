using System;
using System.CodeDom.Compiler;
using UnityEngine;

namespace _Scripts
{
    public class ProcMesh : MonoBehaviour
    {
        [SerializeField] private int _width;
        [SerializeField] private int _height;
        [SerializeField] private GameObject _grass;

        private Mesh _mesh;
        private Vector3[] _vertices;
        private int[] _triangles;

        private void Awake()
        {
            Generate();
        }

        private void Generate()
        {
            GetComponent<MeshFilter>().mesh = _mesh = new Mesh();
            _mesh.name = "Procedural Grid";

            _vertices = new Vector3[(_width + 1) * (_height + 1)];
            Vector2[] uv = new Vector2[_vertices.Length];
            Vector4[] tangents = new Vector4[_vertices.Length];
            Vector4 tangent = new Vector4(1f, 0f, 0f, -1f);
            for (int i = 0, y = 0; y <= _height; y++)
            {
                for (int x = 0; x <= _width; x++, i++)
                {
                    _vertices[i] = new Vector3(x, 0, y);
                    uv[i] = new Vector2((float)x / _width, (float)y / _height);
                }
            }

            _mesh.vertices = _vertices;
            _mesh.tangents = tangents;
            _mesh.uv = uv;

            int[] triangles = new int[_width * _height * 6];
            for (int ti = 0, vi = 0, y = 0; y < _height; y++, vi++)
            {
                for (int x = 0; x < _width; x++, ti += 6, vi++)
                {
                    triangles[ti] = vi;
                    triangles[ti + 3] = triangles[ti + 2] = vi + 1;
                    triangles[ti + 4] = triangles[ti + 1] = vi + _width + 1;
                    triangles[ti + 5] = vi + _width + 2;
                }
            }

            _mesh.triangles = triangles;
            _mesh.RecalculateNormals();
        }

        private void Start()
        {
            /*for (int i = 0, y = 0; y <= _height; y++)
            {
                for (int x = 0; x <= _width; x++, i++)
                {
                    Instantiate(_grass);
                    _grass.transform.position = _vertices[i];
                }
            }*/
        }
    }
}