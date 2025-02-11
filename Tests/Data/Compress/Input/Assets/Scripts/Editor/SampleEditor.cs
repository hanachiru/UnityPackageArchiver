using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(Sample))]
public class SampleEditor : Editor
{
    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        var textProperty = serializedObject.FindProperty("text");
        EditorGUILayout.PropertyField(textProperty);
        serializedObject.ApplyModifiedProperties();
    }
}
