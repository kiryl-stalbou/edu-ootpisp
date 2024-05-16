#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tinyxml2.h"
#include "json.h"

// clang++ -dynamiclib -o xml_codec.dylib -I tinyxml2/ -I json-c/ xml_codec.cpp tinyxml2/tinyxml2.cpp json-c/build/libjson-c.a

// Define the Object structure
struct Object
{
    int icon;
    char *name;
    long long color;
    unsigned int iconColor;
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
    // Parse JSON string to obtain list of objects
    struct json_object *jsonRoot = json_tokener_parse(jsonString);
    if (jsonRoot == NULL || !json_object_is_type(jsonRoot, json_type_array))
    {
        fprintf(stderr, "Error parsing JSON.\n");
        return;
    }

    int arrayLen = json_object_array_length(jsonRoot);
    if (arrayLen == 0)
    {
        fprintf(stderr, "Empty JSON array.\n");
        return;
    }

    // Create XML document
    tinyxml2::XMLDocument doc;
    tinyxml2::XMLElement *root = doc.NewElement("objects");
    doc.InsertFirstChild(root);

    // Iterate over each object in the JSON array
    for (int i = 0; i < arrayLen; ++i)
    {
        struct json_object *jsonObj = json_object_array_get_idx(jsonRoot, i);

        struct Object obj;
        obj.icon = json_object_get_int(json_object_object_get(jsonObj, "icon"));
        obj.name = strdup(json_object_get_string(json_object_object_get(jsonObj, "name")));
        obj.color = json_object_get_int64(json_object_object_get(jsonObj, "color"));
        obj.iconColor = json_object_get_int(json_object_object_get(jsonObj, "iconColor"));
        obj.dimension = json_object_get_double(json_object_object_get(jsonObj, "dimension"));
        obj.cornerRadius = json_object_get_double(json_object_object_get(jsonObj, "cornerRadius"));

        createObjectXMLElement(&doc, root, obj);

        free(obj.name);
    }

    json_object_put(jsonRoot); // Release JSON object

    // Save XML document to file
    doc.SaveFile("lib/ffi_out.xml");
}

// Function to read XML file and return JSON string
extern "C" const char *read()
{
    struct json_object *jsonRoot = json_object_new_array();

    // Open the XML file for reading
    tinyxml2::XMLDocument doc;
    if (doc.LoadFile("lib/software.xml") != tinyxml2::XML_SUCCESS)
    {
        fprintf(stderr, "Error loading XML file.\n");
        return NULL;
    }

    // Parse XML data to obtain list of objects
    tinyxml2::XMLElement *root = doc.FirstChildElement("objects");
    if (root != NULL)
    {
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
            json_object_object_add(jsonObj, "iconColor", json_object_new_int(obj.iconColor));
            json_object_object_add(jsonObj, "dimension", json_object_new_double(obj.dimension));
            json_object_object_add(jsonObj, "cornerRadius", json_object_new_double(obj.cornerRadius));

            json_object_array_add(jsonRoot, jsonObj);

            free(obj.name);
        }
    }

    // Serialize JSON data to string and return
    const char *jsonString = json_object_to_json_string_ext(jsonRoot, JSON_C_TO_STRING_PLAIN);
    json_object_put(jsonRoot); // Release JSON object

    return jsonString;
}
// Helper function to create XML element for an object
void createObjectXMLElement(tinyxml2::XMLDocument *doc, tinyxml2::XMLElement *parent, struct Object obj)
{
    tinyxml2::XMLElement *objElem = doc->NewElement("item"); // Change "object" to "item"
    parent->InsertEndChild(objElem);

    // Set attribute values with proper formatting
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
    // Parse JSON string to obtain list of objects
    struct json_object *jsonRoot = json_tokener_parse(jsonString);
    if (jsonRoot == NULL || !json_object_is_type(jsonRoot, json_type_array))
    {
        fprintf(stderr, "Error parsing JSON.\n");
        return;
    }

    int arrayLen = json_object_array_length(jsonRoot);
    if (arrayLen == 0)
    {
        fprintf(stderr, "Empty JSON array.\n");
        return;
    }

    // Create XML document
    tinyxml2::XMLDocument doc;
    tinyxml2::XMLElement *root = doc.NewElement("root"); // Add a root element
    doc.InsertFirstChild(root);

    // Iterate over each object in the JSON array
    for (int i = 0; i < arrayLen; ++i)
    {
        struct json_object *jsonObj = json_object_array_get_idx(jsonRoot, i);

        struct Object obj;
        obj.icon = json_object_get_int(json_object_object_get(jsonObj, "icon"));
        obj.name = strdup(json_object_get_string(json_object_object_get(jsonObj, "name")));
        obj.color = json_object_get_int64(json_object_object_get(jsonObj, "color"));
        obj.iconColor = json_object_get_int(json_object_object_get(jsonObj, "iconColor"));
        obj.dimension = json_object_get_double(json_object_object_get(jsonObj, "dimension"));
        obj.cornerRadius = json_object_get_double(json_object_object_get(jsonObj, "cornerRadius"));

        createObjectXMLElement(&doc, root, obj);

        free(obj.name);
    }

    json_object_put(jsonRoot); // Release JSON object

    // Save XML document to file
    doc.SaveFile("lib/software.xml");
}
