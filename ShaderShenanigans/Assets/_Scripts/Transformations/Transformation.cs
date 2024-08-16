using UnityEngine;

namespace _Scripts
{
    public abstract class Transformation : MonoBehaviour {

        public abstract Vector3 Apply (Vector3 point);
    }
}