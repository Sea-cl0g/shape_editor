//エラーを解析、判断→無理
//厳格名読み込み

class Theme{
    JSONObject variableJSON = new JSONObject();

    ArrayList<ArrayList<Object>> main = new ArrayList<ArrayList<Object>>();
    ArrayList<ArrayList<Object>> fillPallet = new ArrayList<ArrayList<Object>>();
    ArrayList<ArrayList<Object>> strokePallet = new ArrayList<ArrayList<Object>>();
    ArrayList<ArrayList<Object>> option = new ArrayList<ArrayList<Object>>();
    ArrayList<ArrayList<Object>> export = new ArrayList<ArrayList<Object>>();
    ArrayList<ArrayList<Object>> save = new ArrayList<ArrayList<Object>>();
    ArrayList<ArrayList<Object>> load = new ArrayList<ArrayList<Object>>();

    boolean isFillMode, isStrokeMode, isSaveMode, isLoadMode;

    int setLayerAtPosition(ArrayList<ArrayList<Object>> layers, int index){
        ArrayList<Object> newLayer = new ArrayList<Object>();
        newLayer.add(index);
        if(layers.size() > 0){
            int i = 0;
            while(i < layers.size()){
                int cmpIndex = (int) layers.get(i).get(0);
                if(index < cmpIndex){
                    break;
                }else if(index == cmpIndex){
                    return i;
                }
                i++;
            }
            layers.add(i, newLayer);
            return i;
        }else{
            layers.add(newLayer);
            return 0;
        }
    }

    //====================================================================================================
    int width_buffer, height_buffer;
    boolean isWindowSizeChanged;
    void drawGUI(){
        rectMode(CORNER);
        isWindowSizeChanged = false;
        if(width != width_buffer || height != height_buffer){
            isWindowSizeChanged = true;
            width_buffer = width;
            height_buffer = height;
        }
        
        //ステータスを調べる
        checkLayerStatus(load, !isLoadMode);
        checkLayerStatus(save, !isSaveMode);
        checkLayerStatus(export);
        checkLayerStatus(option);
        checkLayerStatus(strokePallet, !isStrokeMode);
        checkLayerStatus(fillPallet, !isFillMode);
        checkLayerStatus(main);

        //レイヤーの描画を行う
        drawLayer(main);
        if(isFillMode){
            drawLayer(fillPallet);
        }
        if(isStrokeMode){
            drawLayer(strokePallet);
        }
        drawLayer(option);
        drawLayer(export);
        if(isSaveMode){
            drawLayer(save);
        }
        if(isLoadMode){
            drawLayer(load);
        }
    }

    void checkLayerStatus(ArrayList<ArrayList<Object>> layers){
        checkLayerStatus(layers, false);
    }
    void checkLayerStatus(ArrayList<ArrayList<Object>> layers, boolean onlySizeCheck){
        for(int i = layers.size() - 1; 0 <= i; i--){
            ArrayList<Object> eachLayer = layers.get(i);
            for(int q = eachLayer.size() - 1; 0 <= q; q--){
                Object guiObj = eachLayer.get(q);
                if(guiObj.getClass() == Base.class){
                    Base base = (Base) guiObj;
                    if(isWindowSizeChanged){
                        base.sizeW = width;
                        base.sizeH = height;
                    }
                    if(!onlySizeCheck){
                        base.checkStatus(mouseX, mouseY);
                    }
                }else if(guiObj.getClass() == TextBlock.class){
                    TextBlock textBlock = (TextBlock) guiObj;
                    if(isWindowSizeChanged){
                        textBlock.sizeW = width;
                        textBlock.sizeH = height;
                    }
                    if(!onlySizeCheck){
                        textBlock.checkStatus(mouseX, mouseY);
                    }
                }else if(guiObj.getClass() == TextEditor.class){
                    TextEditor textEditor = (TextEditor) guiObj;
                    if(isWindowSizeChanged){
                        textEditor.sizeW = width;
                        textEditor.sizeH = height;
                    }
                    if(!onlySizeCheck){
                        textEditor.checkStatus(mouseX, mouseY);
                    }
                }else if(guiObj.getClass() == ColorPicker.class){
                    ColorPicker colorPicker = (ColorPicker) guiObj;
                    if(isWindowSizeChanged){
                        colorPicker.sizeW = width;
                        colorPicker.sizeH = height;
                    }
                    if(!onlySizeCheck){
                        colorPicker.checkStatus(mouseX, mouseY);
                    }
                }else if(guiObj.getClass() == CanvasBlock.class){
                    CanvasBlock canvasBlock = (CanvasBlock) guiObj;
                    if(isWindowSizeChanged){
                        canvasBlock.sizeW = width;
                        canvasBlock.sizeH = height;
                    }
                    if(!onlySizeCheck){
                        canvasBlock.checkShapesStatus();
                        canvas.process();
                    }
                }else if(guiObj.getClass() == Easel.class){
                    Easel easel = (Easel) guiObj;
                    if(isWindowSizeChanged){
                        easel.sizeW = width;
                        easel.sizeH = height;
                    }
                }else if(guiObj.getClass() == ImageBlock.class){
                    ImageBlock imageBlock = (ImageBlock) guiObj;
                    if(isWindowSizeChanged){
                        imageBlock.sizeW = width;
                        imageBlock.sizeH = height;
                    }
                    if(!onlySizeCheck){
                        imageBlock.checkStatus(mouseX, mouseY);
                    }
                }else if(guiObj.getClass() == Button.class){
                    Button button = (Button) guiObj;
                    if(isWindowSizeChanged){
                        button.sizeW = width;
                        button.sizeH = height;
                    }
                    if(!onlySizeCheck){
                        button.checkStatus(mouseX, mouseY);
                    }
                }
            }
        }
    }

    void drawLayer(ArrayList<ArrayList<Object>> layers){
        for(ArrayList<Object> eachLayer : layers){
            for(Object guiObj : eachLayer){
                if(guiObj.getClass() == Base.class){
                    Base base = (Base) guiObj;
                    base.drawBase();
                }else if(guiObj.getClass() == TextBlock.class){
                    TextBlock textBlock = (TextBlock) guiObj;
                    textBlock.drawTextBlock();
                }else if(guiObj.getClass() == TextEditor.class){
                    TextEditor textEditor = (TextEditor) guiObj;
                    textEditor.drawTextBlock();
                }else if(guiObj.getClass() == ColorPicker.class){
                    ColorPicker colorPicker = (ColorPicker) guiObj;
                    colorPicker.drawColPicker();
                }else if(guiObj.getClass() == CanvasBlock.class){
                    CanvasBlock canvasBlock = (CanvasBlock) guiObj;
                    canvasBlock.drawEasel();
                    canvasBlock.drawItems();
                }else if(guiObj.getClass() == Easel.class){
                    Easel easel = (Easel) guiObj;
                    easel.drawEasel();
                }else if(guiObj.getClass() == ImageBlock.class){
                    ImageBlock imageBlock = (ImageBlock) guiObj;
                    imageBlock.drawImageBlock();
                }else if(guiObj.getClass() == Button.class){
                    Button button = (Button) guiObj;
                    button.drawButton();
                }
            }
        }
    }
    //====================================================================================================
    void loadTheme(){
        println("Theme Loading...");
        JSONObject assets = config.getJSONObject("assets");
        for(Object assetNameObj : assets.keys()){
            String assetName = (String) assetNameObj;
            JSONObject asset = assets.getJSONObject(assetName);
            JSONObject designJSON = safeLoad.assetLoad(asset.getString("path"));
            if(designJSON.keys().size() != 0){
                String layerName = asset.getString("layerMode") != null ? asset.getString("layerMode") : "main";
                switch (layerName) {
                    case "fillPallet" :
                        readDesign(fillPallet, asset, designJSON);
                    break;	
                    case "strokePallet" :
                        readDesign(strokePallet, asset, designJSON);
                    break;	
                    case "option" :
                        readDesign(option, asset, designJSON);
                    break;	
                    case "export" :
                        readDesign(export, asset, designJSON);
                    break;	
                    case "save" :
                        readDesign(save, asset, designJSON);
                    break;	
                    case "load" :
                        readDesign(load, asset, designJSON);
                    break;	
                    default :
                        readDesign(main, asset, designJSON);
                    break;	
                }
            }
        }
        println("main");
        println(main);
        println("fillPallet");
        println(fillPallet);
        println("strokePallet");
        println(strokePallet);
        println("option");
        println(option);
        println("export");
        println(export);
        println("save");
        println(save);
        println("load");
        println(load);
    }

    void readDesign(ArrayList<ArrayList<Object>> layers, JSONObject asset, JSONObject designJSON){
        buildVariableJSON(designJSON);
        JSONObject elements = designJSON.getJSONObject("elements");
        JSONArray configQuery = asset.getJSONArray("queries");
        DrawMode drawMode = new DrawMode(designJSON);

        int layerPos = setLayerAtPosition(layers, designJSON.isNull("layer") ? 0 : designJSON.getInt("layer"));

        String[] elementNameList = getReverseSortedStringArrayFromJSONObject(elements);
        
        for(String elementName : elementNameList){
            boolean isElementQuery = false;
            String queryType = null;
            if(configQuery != null){
                for(int i = 0; i < configQuery.size(); i++){
                    if(configQuery.getJSONObject(i).getString("Name").equals(elementName)){
                        isElementQuery = true;
                        queryType = configQuery.getJSONObject(i).getString("Query");
                    }
                }
            }
            //if(asset)//configで定義された特別な要素かを調べる
            EasyJSONObject elementEJSON = new EasyJSONObject(elements.getJSONObject(elementName));
            LayoutData layout;
            TextData textData;
            ImageData imageData;
            color fillCol;
            StrokeData stroke;
            switch (elementEJSON.safeGetString("type")) {
                case "base" :
                    layout = new LayoutData(elementEJSON.get("layout"), variableJSON);
                    fillCol = readColor(elementEJSON.safeGetString("fillCol"), variableJSON);
                    stroke = new StrokeData(elementEJSON.get("stroke"), variableJSON);
                    layers.get(layerPos).add(new Base(16, 16, drawMode, layout, stroke, fillCol));
                break;
                case "text_block" :
                    layout = new LayoutData(elementEJSON.get("layout"), variableJSON);
                    textData = new TextData(elementEJSON.get("text"), variableJSON);
                    stroke = new StrokeData(elementEJSON.get("stroke"), variableJSON);
                    fillCol = readColor(elementEJSON.safeGetString("fillCol"), variableJSON);
                    layers.get(layerPos).add(new TextBlock(16, 16, drawMode, layout, textData, stroke, fillCol));
                break;
                case "text_editor" :
                    layout = new LayoutData(elementEJSON.get("layout"), variableJSON);
                    textData = new TextData(elementEJSON.get("text"), variableJSON);
                    stroke = new StrokeData(elementEJSON.get("stroke"), variableJSON);
                    fillCol = readColor(elementEJSON.safeGetString("fillCol"), variableJSON);
                    layers.get(layerPos).add(new TextEditor(16, 16, drawMode, layout, textData, stroke, fillCol));
                break;
                case "color_picker" :
                    layout = new LayoutData(elementEJSON.get("layout"), variableJSON);
                    int colorPalletIndex = -1;
                    String pickerMode = "";
                    if(isElementQuery){
                        if(elementName.startsWith("@FILL_")){
                            colorPalletIndex = 0;
                        }else if(elementName.startsWith("@STROKE_")){
                            colorPalletIndex = 1;
                        }
                        pickerMode = getPickerMode(elementName);
                    }
                    layers.get(layerPos).add(new ColorPicker(16, 16, drawMode, layout, colorPalletIndex, pickerMode));
                break;
                case "canvas" :
                    layout = new LayoutData(elementEJSON.get("layout"), variableJSON);
                    fillCol = readColor(elementEJSON.safeGetString("fillCol"), variableJSON);
                    layers.get(layerPos).add(new CanvasBlock(16, 16, drawMode, layout, fillCol));
                break;	
                case "easel" :
                    layout = new LayoutData(elementEJSON.get("layout"), variableJSON);
                    fillCol = readColor(elementEJSON.safeGetString("fillCol"), variableJSON);
                    layers.get(layerPos).add(new Easel(16, 16, drawMode, layout, fillCol));
                break;
                case "image_block" :
                    layout = new LayoutData(elementEJSON.get("layout"), variableJSON);
                    imageData = new ImageData(elementEJSON.get("image"), variableJSON);
                    layers.get(layerPos).add(new ImageBlock(16, 16, drawMode, layout, imageData));
                break;
                case "button" :
                    Runnable function = null;
                    int colorIndex = -1;
                    if(isElementQuery){
                        if(elementName.equals("@MAIN_BUTTON")){
                            function = buttonFanctionPrepare(queryType);
                        }else if(elementName.equals("@FILL_BUTTON")){
                            function = buttonFanctionPrepare(queryType);
                            if(queryType.equals("TGL_FILL_PALLET_MODE")){
                                colorIndex = 0;
                            }else if(queryType.equals("TGL_STROKE_PALLET_MODE")){
                                colorIndex = 1;
                            }
                        }
                    }
                    EasyJSONArray styles = elementEJSON.safeGetEasyJSONArray("style");
                    Button button = buildButton(drawMode, styles, function);
                    if(colorIndex != -1){
                        button.colorIndex = colorIndex;
                    }
                    layers.get(layerPos).add(button);
                break;
            }
        }
    }

    String getPickerMode(String elementName){
        if(elementName.endsWith("_HSB_H")){
            return "HSB_H";
        }else if(elementName.endsWith("_HSB_S")){
            return "HSB_S";
        }else if(elementName.endsWith("_HSB_B")){
            return "HSB_B";
        }else if(elementName.endsWith("_RGB_R")){
            return "HSB_R";
        }else if(elementName.endsWith("_RGB_G")){
            return "HSB_G";
        }else if(elementName.endsWith("_RGB_B")){
            return "HSB_B";
        }else if(elementName.endsWith("_ALPHA")){
            return "ALPHA";
        }else if(elementName.endsWith("STROKE_WEIGHT")){
            return "STROKE_WEIGHT";
        }
        return "";
    }

    Runnable buttonFanctionPrepare(String query){
        Runnable function;
        println(query);
        switch (query) {
            case "FANC_ADD_RECTANGLE" :
                function = () -> canvas.add_rectangle();
            break;
            case "FANC_ADD_ELLIPSE" :
                function = () -> canvas.add_ellipse();
            break;
            case "TGL_STROKE_PALLET_MODE" :
                function = () -> canvas.tgl_fillPallet_mode();
            break;	
            case "TGL_FILL_PALLET_MODE" :
                function = () -> canvas.tgl_strokePallet_mode();
            break;	
            case "TGL_SAVE_MODE" :
                function = () -> canvas.tgl_save_mode();
            break;	
            case "TGL_LOAD_MODE" :
                function = () -> canvas.tgl_load_mode();
            break;	
            case "FANC_EXPORT_TO_PROCESSING" :
                function = () -> canvas.convert_code();
            break;	
            default:
                function = null;
            break;
        }
        println(function);
        return function;
    }

    Button buildButton(DrawMode drawMode, EasyJSONArray styleList, Runnable function){
        StyleData normal = new StyleData();
        StyleData touched = new StyleData();
        StyleData clicked = new StyleData();
        StyleData selected = new StyleData();
        for(int i = 0; i < styleList.size(); i++){
            EasyJSONObject style = styleList.safeGetEasyJSONObject(i);
            Object predicateObj = style.get("predicate");
            JSONArray query = new JSONArray();
            if(predicateObj.getClass() == String.class){
                String predicate_tmp = (String) predicateObj;
                query.append(predicate_tmp);
            }else{
                query = (JSONArray) predicateObj;
            }
            for(int q = 0; q < query.size(); q++){
                switch (query.getString(q)) {
                    case "normal" :
                        normal.readData(style, variableJSON);
                    break;
                    case "touched" :
                        touched.readData(style, variableJSON);
                    break;	
                    case "clicked" :
                        clicked.readData(style, variableJSON);
                    break;
                    case "selected" :
                        selected.readData(style, variableJSON);
                    break;
                }
            }
        }
        return new Button(16, 16, drawMode, normal, touched, clicked, function);
    }

    void buildVariableJSON(JSONObject design){
        for(Object keyObj : design.keys()){
            String key = (String) keyObj;
            if(!key.equals("elements")){
                Object valueObj = design.get(key);
                if(valueObj.getClass() == JSONObject.class){
                    JSONObject value = (JSONObject) valueObj;
                    variableJSON.setJSONObject(key, value);
                }
            }
        }
    }
}

//--------------------------------------------------
class DrawMode{
    String containerAnker, blockMode, blockAnker;

    DrawMode(JSONObject drawModeJSON){
        EasyJSONObject drawModeEJSON = new EasyJSONObject(drawModeJSON);
        this.containerAnker = drawModeEJSON.safeGetString("containerAnker", "topLeft");
        this.blockMode = drawModeEJSON.safeGetString("blockMode", "vertical");
        this.blockAnker = drawModeEJSON.safeGetString("blockAnker", "CORNER");
    }
}

//--------------------------------------------------
class StyleData{
    String buttonType;
    color fillCol;
    LayoutData layoutData;
    StrokeData strokeData;
    ImageData imageData;
    ShadowData shadowData;

    void readData(EasyJSONObject styleEJSON, JSONObject variableJSON){
        buttonType = readButtonType(styleEJSON.safeGetString("button_type"), variableJSON);

        fillCol = readColor(styleEJSON.safeGetString("fill"), variableJSON);
        layoutData = new LayoutData(styleEJSON.get("layout"), variableJSON);
        strokeData = new StrokeData(styleEJSON.get("stroke"), variableJSON);
        imageData = new ImageData(styleEJSON.get("image"), variableJSON);
        shadowData = new ShadowData(styleEJSON.get("shadow"), variableJSON);
    }
    
    String readButtonType(String buttonTypeData, JSONObject variableJSON){
        if(buttonTypeData.startsWith("$")){
            String variableName = buttonTypeData.substring(1);
            return variableJSON.getJSONObject("button_types").getString(variableName);

        }
        return buttonTypeData;
    }
}

//--------------------------------------------------
class LayoutData{
    float x_point, y_point, width_point, height_point;
    float r_point, tl_point, tr_point, br_point, bl_point;

    LayoutData(Object layoutObj, JSONObject variableJSON){
        if(layoutObj != null){
            EasyJSONObject layoutEJSON = new EasyJSONObject();
            if(layoutObj.getClass() == String.class){
                String layoutStr = (String) layoutObj;
                if(layoutStr.startsWith("$")){
                    String variableName = layoutStr.substring(1);
                    layoutEJSON = new EasyJSONObject(variableJSON.getJSONObject("layouts").getJSONObject(variableName));
                }
            }else if(layoutObj.getClass() == JSONObject.class){
                JSONObject layoutJSON = (JSONObject) layoutObj;
                layoutEJSON = new EasyJSONObject(layoutJSON);
            }else{
                layoutEJSON = new EasyJSONObject();
            }
            this.x_point = readFloat(layoutEJSON.get("x_point"), variableJSON);
            this.y_point = readFloat(layoutEJSON.get("y_point"), variableJSON);
            this.width_point = readFloat(layoutEJSON.get("width_point"), variableJSON);
            this.height_point = readFloat(layoutEJSON.get("height_point"), variableJSON);
            this.r_point = readFloat(layoutEJSON.get("r_point"), variableJSON);
            this.tl_point = readFloat(layoutEJSON.get("tl_point"), variableJSON);
            this.tr_point = readFloat(layoutEJSON.get("tr_point"), variableJSON);
            this.br_point = readFloat(layoutEJSON.get("br_point"), variableJSON);
            this.bl_point = readFloat(layoutEJSON.get("bl_point"), variableJSON);
        }
    }
}

//--------------------------------------------------
class StrokeData{
    float stroke_point;
    color strokeCol;

    StrokeData(Object strokeObj, JSONObject variableJSON){
        if(strokeObj != null){
            EasyJSONObject strokeEJSON = new EasyJSONObject();
            if(strokeObj.getClass() == String.class){
                String strokeStr = (String) strokeObj;
                if(strokeStr.startsWith("$")){
                    String variableName = strokeStr.substring(1);
                    strokeEJSON = new EasyJSONObject(variableJSON.getJSONObject("strokes").getJSONObject(variableName));
                }
            }else if(strokeObj.getClass() == JSONObject.class){
                JSONObject strokeJSON = (JSONObject) strokeObj;
                strokeEJSON = new EasyJSONObject(strokeJSON);
            }else{
                strokeEJSON = new EasyJSONObject();
            }
            this.stroke_point = readFloat(strokeEJSON.get("stroke_point"), variableJSON);
            this.strokeCol = readColor(strokeEJSON.safeGetString("color"), variableJSON);
        }
    }
}

//--------------------------------------------------
class ImageData{
    float size;
    PShape svg;
    PImage image;
    boolean svgTgl;

    ImageData(Object imageObj, JSONObject variableJSON){
        if(imageObj != null){
            EasyJSONObject imageEJSON = new EasyJSONObject();
            if(imageObj.getClass() == String.class){
                String imageStr = (String) imageObj;
                if(imageStr.startsWith("$")){
                    String variableName = imageStr.substring(1);
                    imageEJSON = new EasyJSONObject(variableJSON.getJSONObject("images").getJSONObject(variableName));
                }
            }else if(imageObj.getClass() == JSONObject.class){
                JSONObject imageJSON = (JSONObject) imageObj;
                imageEJSON = new EasyJSONObject(imageJSON);
            }else{
                imageEJSON = new EasyJSONObject();
            }
            this.size = readFloat(imageEJSON.get("size"), variableJSON);
            String path = imageEJSON.safeGetString("path");
            svgTgl = false;
            if(path.endsWith(".svg")){
                this.svg = safeLoad.svgLoad(path);
                svgTgl = true;
            }else{
                this.image = safeLoad.imageLoad(path);
            }
        }
    }

    void changeImageColor(PShape shape, color overrideCol){
        if(0 < shape.getChildCount()){
            for(int i = 0; i < shape.getChildCount(); i++){
                changeImageColor(shape.getChild(i), overrideCol);
            }
        }else{
            shape.setFill(overrideCol);
        }
    }
}

//--------------------------------------------------
class ShadowData{
    String shadowMode;
    float shadowDistPoint;
    color shadowCol;
    
    ShadowData(Object shadowObj, JSONObject variableJSON){
        if(shadowObj != null){
            EasyJSONObject shadowEJSON = new EasyJSONObject();
            if(shadowObj.getClass() == String.class){
                String shadowStr = (String) shadowObj;
                if(shadowStr.startsWith("$")){
                    String variableName = shadowStr.substring(1);
                    shadowEJSON = new EasyJSONObject(variableJSON.getJSONObject("shadows").getJSONObject(variableName));
                }
            }else if(shadowObj.getClass() == JSONObject.class){
                JSONObject shadowJSON = (JSONObject) shadowObj;
                shadowEJSON = new EasyJSONObject(shadowJSON);
            }else{
                shadowEJSON = new EasyJSONObject();
            }
            this.shadowMode = shadowEJSON.safeGetString("shadowMode");
            this.shadowDistPoint = readFloat(shadowEJSON.get("shadowDistPoint"), variableJSON);
            this.shadowCol = readColor(shadowEJSON.safeGetString("color"), variableJSON);
        }
    }
}

//--------------------------------------------------
class TextData{
    String text;
    String textAlign;
    float textSize;
    color textColor;
    
    TextData(Object textObj, JSONObject variableJSON){
        if(textObj != null){
            EasyJSONObject textEJSON = new EasyJSONObject();
            if(textObj.getClass() == String.class){
                String textStr = (String) textObj;
                if(textStr.startsWith("$")){
                    String variableName = textStr.substring(1);
                    textEJSON = new EasyJSONObject(variableJSON.getJSONObject("texts").getJSONObject(variableName));
                }
            }else if(textObj.getClass() == JSONObject.class){
                JSONObject textJSON = (JSONObject) textObj;
                textEJSON = new EasyJSONObject(textJSON);
            }else{
                textEJSON = new EasyJSONObject();
            }
            this.text = textEJSON.safeGetString("text");
            this.textAlign = textEJSON.safeGetString("text_align");
            this.textSize = readFloat(textEJSON.get("text_size"), variableJSON);
            this.textColor = readColor(textEJSON.safeGetString("text_col"), variableJSON);
        }
    }
}

//--------------------------------------------------
color hexToColor(String hex){
    if (hex.startsWith("#")) {
        hex = hex.substring(1);
    }
    
    int r = unhex(hex.substring(0, 2));
    int g = unhex(hex.substring(2, 4));
    int b = unhex(hex.substring(4, 6));
    int a = hex.length() == 8 ? unhex(hex.substring(6, 8)) : 255;
    return color(r, g, b, a);
}

color readColor(String colorPool, JSONObject variableJSON){
    if(colorPool.startsWith("$")){
        String variableName = colorPool.substring(1);
        return hexToColor(variableJSON.getJSONObject("colors").getString(variableName));
    }
    return hexToColor(colorPool);
}

float readFloat(Object objPool, JSONObject variableJSON){if(objPool != null){
        if(objPool instanceof Number){
            return ((Number) objPool).floatValue();
        }else if(objPool.getClass() == String.class){
            String floatPool = objPool.toString();
            String[] pool = splitTokens(floatPool);
            for(int i = 0; i < pool.length; i++){
                if(pool[i].startsWith("$")){
                    String variableName = pool[i].substring(1);
                    float variable = 0.0;
                    if(!variableJSON.getJSONObject("floats").isNull(variableName)){
                        variable = variableJSON.getJSONObject("floats").getFloat(variableName);
                    }
                    pool[i] = String.valueOf(variable);
                }
            }
            return calculateExpression(pool);
        }
    }
    return 0.0;
}

float calculateExpression(String[] tokens){
  float result = Float.parseFloat(tokens[0]);

  for(int i = 1; i < tokens.length; i += 2){
    String operator = tokens[i];
    float operand = Float.parseFloat(tokens[i + 1]);
    
    switch (operator){
      case "+":
        result += operand;
        break;
      case "-":
        result -= operand;
        break;
      case "*":
        result *= operand;
        break;
      case "/":
        result /= operand;
        break;
      default:
        throw new IllegalArgumentException("Unsupported operator: " + operator);
    }
  }
  return result;
}
