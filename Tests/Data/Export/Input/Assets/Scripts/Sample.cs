using UnityEngine;

public class Sample : MonoBehaviour
{
    [SerializeField]
    [HideInInspector]
    [TextArea(3, 10)]
    private string text;
}
