#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tinyxml2.h"
#include "json.h"

// clang++ -dynamiclib -o xml_codec.dylib -I tinyxml2/ -I json-c/ tinyxml2/tinyxml2.cpp json-c/libjson-c.a xml_codec.cpp

struct Object
{
    int icon;
    char *name;
    long long color;
    long long iconColor;
    float dimension;
    double cornerRadius;
};

// Helper function to create XML element for an object
void createObjectXMLElement(tinyxml2::XMLDocument *doc, tinyxml2::XMLElement *parent, struct Object obj)
{
    tinyxml2::XMLElement *objElem = doc->NewElement("object");
    parent->InsertEndChild(objElem);

    objElem->SetAttribute("icon", obj.icon);
    objElem->SetAttribute("name", obj.name);
    objElem->SetAttribute("color", obj.color);
    objElem->SetAttribute("iconColor", obj.iconColor);
    objElem->SetAttribute("dimension", obj.dimension);
    objElem->SetAttribute("cornerRadius", obj.cornerRadius);
}

// Function to write JSON string to XML file
extern "C" void write(const char *jsonString)
{
    struct json_object *jsonRoot = json_tokener_parse(jsonString);
    if (jsonRoot == NULL || !json_object_is_type(jsonRoot, json_type_array))
    {
        fprintf(stderr, "Error parsing JSON.\n");
        return;
    }

    int arrayLen = json_object_array_length(jsonRoot);

    tinyxml2::XMLDocument doc;
    tinyxml2::XMLElement *root = doc.NewElement("objects");
    doc.InsertFirstChild(root);

    for (int i = 0; i < arrayLen; ++i)
    {
        struct json_object *jsonObj = json_object_array_get_idx(jsonRoot, i);

        struct Object obj;
        obj.icon = json_object_get_int(json_object_object_get(jsonObj, "icon"));
        obj.name = strdup(json_object_get_string(json_object_object_get(jsonObj, "name")));
        obj.color = json_object_get_int64(json_object_object_get(jsonObj, "color"));
        obj.iconColor = json_object_get_int64(json_object_object_get(jsonObj, "iconColor"));
        obj.dimension = json_object_get_double(json_object_object_get(jsonObj, "dimension"));
        obj.cornerRadius = json_object_get_double(json_object_object_get(jsonObj, "cornerRadius"));

        createObjectXMLElement(&doc, root, obj);

        free(obj.name);
    }

    json_object_put(jsonRoot);

    doc.SaveFile("lib/software.xml");
}

// Function to read XML file and return JSON string
extern "C" const char *read()
{
    struct json_object *jsonRoot = json_object_new_array();

    tinyxml2::XMLDocument doc;
    if (doc.LoadFile("lib/software.xml") != tinyxml2::XML_SUCCESS)
    {
        fprintf(stderr, "Error loading XML file.\n");
        json_object_put(jsonRoot);
        return NULL;
    }

    tinyxml2::XMLElement *root = doc.FirstChildElement("objects");
    if (root == NULL || root->FirstChildElement("object") == NULL)
    {
        fprintf(stderr, "Empty or missing XML root element.\n");
        json_object_put(jsonRoot);
        return NULL;
    }

    for (tinyxml2::XMLElement *objElem = root->FirstChildElement("object"); objElem != NULL; objElem = objElem->NextSiblingElement("object"))
    {
        struct Object obj;
        obj.icon = objElem->IntAttribute("icon");
        obj.name = strdup(objElem->Attribute("name"));
        obj.color = atoll(objElem->Attribute("color"));
        obj.iconColor = atoi(objElem->Attribute("iconColor"));
        obj.dimension = objElem->FloatAttribute("dimension");
        obj.cornerRadius = objElem->DoubleAttribute("cornerRadius");

        struct json_object *jsonObj = json_object_new_object();
        json_object_object_add(jsonObj, "icon", json_object_new_int(obj.icon));
        json_object_object_add(jsonObj, "name", json_object_new_string(obj.name));
        json_object_object_add(jsonObj, "color", json_object_new_int64(obj.color));
        json_object_object_add(jsonObj, "iconColor", json_object_new_int64(obj.iconColor));
        json_object_object_add(jsonObj, "dimension", json_object_new_double(obj.dimension));
        json_object_object_add(jsonObj, "cornerRadius", json_object_new_double(obj.cornerRadius));

        json_object_array_add(jsonRoot, jsonObj);

        free(obj.name);
    }

    const char *jsonString = json_object_to_json_string_ext(jsonRoot, JSON_C_TO_STRING_PLAIN);
    char *result = strdup(jsonString); // Ensure the result is properly allocated

    json_object_put(jsonRoot);

    return result;
}

// Function to free the allocated memory for the JSON string
extern "C" void free_string(const char *str)
{
    free((void *)str);
}
