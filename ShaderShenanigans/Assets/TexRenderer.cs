using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TexRenderer : MonoBehaviour
{
    public RenderTexture renderTexture; // Assign in Inspector
    public Material blitMaterial; // Assign in Inspector
    public Camera renderCamera;

    void Start()
    {
        
        // Perform the Blit operation
        Graphics.Blit(renderTexture, null as RenderTexture, blitMaterial);
    }
}
