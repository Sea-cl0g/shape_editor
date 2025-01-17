class ColorPicker extends Block{
    DrawMode drawMode;
    float x, y, w, h;
    int colorPalletIndex;
    String pickerMode;
    int colorMax = 255;
    float pickNum = colorMax / 2;

    ColorPicker(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, int colorPalletIndex, String pickerMode){
        super(splitW, splitH);
        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);
        this.drawMode = drawMode;
        this.pickerMode = pickerMode;
        this.x = layoutData.x_point;
        this.y = layoutData.y_point;
        this.w = layoutData.width_point;
        this.h = layoutData.height_point;
        this.colorPalletIndex = colorPalletIndex;
    }

    void drawColPicker(){
        noStroke();
        drawGradation(colorMax);
        drawPickPoint();
    }

    void checkStatus(float mouseX, float mouseY){
        boolean isTouched = isPointInBox(x, y, w, h, mouseX, mouseY);
        if(!hasMouseTouched && isTouched){
            if(mousePressed && mouseButton == LEFT){
                canvas.colorPallet[colorPalletIndex] = getPickedColor();
                if(colorPalletIndex == 0){
                    fillColorJustChanged = true;
                }else if(colorPalletIndex == 1){
                    strokeColorJustChanged = true;
                }
                isMouseLeftClicking = false;
            }
            hasMouseTouched = true;
        }
    }

    color getPickedColor(){
        float colElement1;
        float colElement2;
        float colElement3;
        float colElement4;

        PVector colorPickerSize = getContainerBlockSize(w, h);
        PVector colorPickerPos = getObjectPos(x, y, w, h, colorPickerSize);
        pickNum = map(mouseX, colorPickerPos.x, colorPickerPos.x + colorPickerSize.x, 0, colorMax);

        if(pickerMode.startsWith("HSB")){
            colElement1 = hue(canvas.colorPallet[colorPalletIndex]);
            colElement2 = saturation(canvas.colorPallet[colorPalletIndex]);
            colElement3 = brightness(canvas.colorPallet[colorPalletIndex]);
            colElement4 = alpha(canvas.colorPallet[colorPalletIndex]);
            colorMode(HSB, 255, 255, 255);
        }else{
            colElement1 = red(canvas.colorPallet[colorPalletIndex]);
            colElement2 = green(canvas.colorPallet[colorPalletIndex]);
            colElement3 = blue(canvas.colorPallet[colorPalletIndex]);
            colElement4 = alpha(canvas.colorPallet[colorPalletIndex]);
            colorMode(RGB, 255, 255, 255);
        }
        color returnCol = color(0, 0, 0);
        if(pickerMode.endsWith("H") || pickerMode.endsWith("R")){
            returnCol = color(pickNum, colElement2, colElement3, colElement4);
        }else if(pickerMode.endsWith("S") || pickerMode.endsWith("G")){
            returnCol = color(colElement1, pickNum, colElement3, colElement4);
        }else if(pickerMode.endsWith("B")){
            returnCol = color(colElement1, colElement2, pickNum, colElement4);
        }else if(pickerMode.endsWith("ALPHA")){
            returnCol = color(colElement1, colElement2, colElement3, pickNum);
        }
        colorMode(RGB, 255, 255, 255);
        
        return returnCol;
    }

    void drawGradation(int max){
        float eachWidth = w / max;
        float colElement1;
        float colElement2;
        float colElement3;
        float colElement4;
        noStroke();
        if(pickerMode.startsWith("HSB")){
            colElement1 = hue(canvas.colorPallet[colorPalletIndex]);
            colElement2 = saturation(canvas.colorPallet[colorPalletIndex]);
            colElement3 = brightness(canvas.colorPallet[colorPalletIndex]);
            colElement4 = alpha(canvas.colorPallet[colorPalletIndex]);
            colorMode(HSB, 255, 255, 255);
        }else{
            colElement1 = red(canvas.colorPallet[colorPalletIndex]);
            colElement2 = green(canvas.colorPallet[colorPalletIndex]);
            colElement3 = blue(canvas.colorPallet[colorPalletIndex]);
            colElement4 = alpha(canvas.colorPallet[colorPalletIndex]);
            colorMode(RGB, 255, 255, 255);
        }
        setBlockAnker("CORNER");
        for(int i = 0; i < max; i++){
            if(pickerMode.endsWith("HSB_H")){
                fill(i, 255, 255, 255);
            }else if(pickerMode.endsWith("HSB_S")){
                fill(colElement1, i, colElement3, 255);
            }else if(pickerMode.endsWith("HSB_B")){
                fill(0, 0, i, 255);
            }else if(pickerMode.endsWith("RGB_R")){
                fill(i, 0, 0, 255);
            }else if(pickerMode.endsWith("RGB_G")){
                fill(0, i, 0, 255);
            }else if(pickerMode.endsWith("RGB_B")){
                fill(0, 0, i, 255);
            }else if(pickerMode.endsWith("ALPHA")){
                fill(colElement1, colElement2, colElement3, i);
            }
            
            int li = max - i - 1;
            if(drawMode.blockAnker.equals("CORNER")){
                box(x + eachWidth * li, y, eachWidth * 2, h);
            }else{
                box(x + eachWidth * li - w / 2, y - h / 2, eachWidth * 2, h);
            }
        }
        colorMode(RGB, 255, 255, 255);
        setBlockAnker(drawMode.blockAnker);
    }

    //元凶。とりあえず、fillCOlのスコープをクラスにして、//4:13の箇所で値が変わった場合のみ色の現在の値を調べる仕組みを作る？
    void drawPickPoint(){
        PVector colorPickerSize = getContainerBlockSize(w, h);
        PVector colorPickerPos = getObjectPos(x, y, w, h, colorPickerSize);
        
        /*
        //1/13 4:13
        if(colorPalletIndex == 0 && fillColorJustChanged){
            pickNum = getCurPickNum(0);
        }else if(colorPalletIndex == 1 && strokeColorJustChanged){
            pickNum = getCurPickNum(1);
        }
        */
        float pointX = map(pickNum, 0, colorMax, colorPickerPos.x, colorPickerPos.x + colorPickerSize.x);
        fill(255);
        stroke(0);
        strokeWeight(1);
        float pointW = 0.1;
        float pointGW = getContainerBlockSize(pointW, pointW).x;
        rect(pointX - pointGW / 2, colorPickerPos.y, pointGW, pointGW);
        rect(pointX - pointGW / 2, colorPickerPos.y + colorPickerSize.y - pointGW, pointGW, pointGW);
    }

    float getCurPickNum(int index){
        if(pickerMode.endsWith("HSB_H")){
            return hue(canvas.colorPallet[index]);
        }else if(pickerMode.endsWith("HSB_S")){
            return saturation(canvas.colorPallet[index]);
        }else if(pickerMode.endsWith("HSB_B")){
            return brightness(canvas.colorPallet[index]);
        }else if(pickerMode.endsWith("RGB_R")){
            return red(canvas.colorPallet[index]);
        }else if(pickerMode.endsWith("RGB_G")){
            return green(canvas.colorPallet[index]);
        }else if(pickerMode.endsWith("RGB_B")){
            return blue(canvas.colorPallet[index]);
        }else if(pickerMode.endsWith("ALPHA")){
            return alpha(canvas.colorPallet[index]);
        }
        return 0;
    }
}

//--------------------------------------------------
class TextBlock extends Base{
    String text;
    String[] textArray;
    boolean isTextArray;
    String textAlign;
    float textSize;
    color textColor;
    PointString importText;
    PointStringArray importTextArray;

    TextBlock(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, TextData textData, StrokeData strokeData, color fillCol){
        super(splitW, splitH, drawMode, layoutData, strokeData, fillCol);
        textPrepare(textData);
    }

    TextBlock(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, TextData textData, StrokeData strokeData, color fillCol, PointString importText){
        super(splitW, splitH, drawMode, layoutData, strokeData, fillCol);
        this.importText = importText;
        textPrepare(textData);
    }

    TextBlock(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, TextData textData, StrokeData strokeData, color fillCol, PointStringArray importTextArray){
        super(splitW, splitH, drawMode, layoutData, strokeData, fillCol);
        this.importTextArray = importTextArray;
        textPrepare(textData);
    }

    void textPrepare(TextData textData){
        this.text = textData.text;
        textArray = getSplitedText(text);
        this.textAlign = textData.textAlign;
        this.textSize = textData.textSize;
        this.textColor = textData.textColor;
    }

    String[] getSplitedText(String str){
        return splitTokens(str, "|");
    }

    void drawTextBlock(){
        if(importText != null){
            text = importText.pool;
            textArray = getSplitedText(text);
        }else if(importTextArray != null){
            textArray = importTextArray.pool;
        }

        if(1 < textArray.length){
            drawTextArray();
        }else{
            drawText();
        }
    }

    void drawText(){
        drawBase();
        fill(textColor);
        float textGSize = getContainerBlockSize(textSize, textSize).y;
        textSize(textGSize);
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);
        switch (textAlign){
            case "CENTER" :
                textAlign(CENTER, CENTER);
                text(text, pos.x + size.x / 2, pos.y + size.y / 2);
            break;	
            case "RIGHT" :
                textAlign(RIGHT, CENTER);
                text(text, pos.x + size.x, pos.y + size.y / 2);
            break;	
            default :
                textAlign(LEFT, CENTER);
                text(text, pos.x, pos.y + size.y / 2);
            break;	
        }
    }

    void drawTextArray(){
        drawBase();
        fill(textColor);
        float textGSize = getContainerBlockSize(textSize, textSize).y;
        textSize(textGSize);
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);
        for(int i = 0; i < min(floor(size.y / textGSize), textArray.length); i++){
            float yPos = pos.y + textGSize / 2 + textGSize * i;
            String str = textArray[i];
            switch (textAlign){
                case "CENTER" :
                    textAlign(CENTER, CENTER);
                    text(str, pos.x + size.x / 2, yPos);
                break;	
                case "RIGHT" :
                    textAlign(RIGHT, CENTER);
                    text(str, pos.x + size.x, yPos);
                break;	
                default :
                    textAlign(LEFT, CENTER);
                    text(str, pos.x, yPos);
                break;	
            }
        }
    }
}

//--------------------------------------------------
class TextEditor extends TextBlock{
    boolean isSelected = false;
    int cursor;
    int th = 4;
    int brinkMax = 60;
    int brinkTimer = 0;
    int keyRepeatMax = 10;
    int keyRepeat = 0;
    PointString exportText;

    TextEditor(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, TextData textData, StrokeData strokeData, color fillCol,  PointString exportText){
        super(splitW, splitH, drawMode, layoutData, textData, strokeData, fillCol);
        this.exportText = exportText;
        this.text = exportText.pool;
    }

    void checkStatus(float mouseX, float mouseY){
        boolean isTouched = isPointInBox(x, y, w, h, mouseX, mouseY);
        if(!hasMouseTouched && isTouched){
            if(isMouseLeftClicking){
                isSelected = true;
                isMouseLeftClicking = false;
                cursor = getCursor();
            }
            hasMouseTouched = true;
        }else{
            if(isMouseLeftClicking){
                isSelected = false;
            }
        }
        if(isSelected){
            if(keyPressed && keyRepeat <= 0){
                editText();
                exportText.pool = text;
                keyRepeat = keyRepeatMax;
            }
            countUpTimer();
        }
        if(0 < keyRepeat){
            keyRepeat--;
        }
    }

    void editText(){
        char[] charArray = text.toCharArray();
        ArrayList<Character> textSplit = new ArrayList<Character>();
        for(char chr : charArray){
            textSplit.add(chr);
        }
        if (isPrintableKey()){
            textSplit.add(cursor + 1, key);
            cursor++;
        }else if(key == CODED && keyCode == LEFT && 0 <= cursor){
          cursor--;
        }else if(key == CODED && keyCode == UP && 0 < cursor){
          cursor = -1;
        }else if(key == CODED && keyCode == RIGHT && cursor < textSplit.size() - 1){
          cursor++;
        }else if(key == CODED && keyCode == DOWN && cursor <= textSplit.size()){
          cursor = textSplit.size() - 1;
        }else if(key == BACKSPACE && 0 <= cursor){
            textSplit.remove(cursor);
            cursor--;
        }else if(key == DELETE && cursor == textSplit.size() && 0 <= cursor){
            textSplit.remove(cursor + 1);
        }
        StringBuilder sb = new StringBuilder();
        for (Character c : textSplit){
            sb.append(c);
        }
        text = sb.toString();
    }

    boolean isPrintableKey(){
        if(key >= 32 && key <= 126){
            return true;
        }
        if(key >= 160 && key <= 255){
           return true;
        }
        return false;
    }

    void countUpTimer(){
        if(brinkTimer < brinkMax){
            brinkTimer++;
        }else{
            brinkTimer = 0;
        }
    }

    void drawTextBlock(){
        super.drawText();
        
        if(isSelected && brinkTimer < brinkMax / 2){
            stroke(textColor);
            strokeWeight(1);
            PVector size = getContainerBlockSize(w, h);
            float boxCenterGpos = getObjectPos(x, y, w, h, size).y + size.y / 2;
            float textGSize = getContainerBlockSize(textSize, textSize).y;
            float textTh = textGSize / 2.0;
            float cursorX = getCursorX();
            line(cursorX, boxCenterGpos - textTh, cursorX, boxCenterGpos + textTh);
        }
    }

    float getBeginX(){
        float textGSize = getContainerBlockSize(textSize, textSize).y;
        textSize(textGSize);
        float textWidth = textWidth(text);
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);
        if(textAlign.equals("CENTER")){
            return pos.x + size.x / 2 - textWidth / 2;
        }else if(textAlign.equals("RIGHT")){
            return pos.x + size.x - textWidth;
        }else if(textAlign.equals("LEFT")){
            return pos.x;
        }
        return -1;
    }

    int getCursor(){
        char[] charArray = text.toCharArray();
        float beginX = getBeginX();

        String buildText = "";
        for(int i = 0; i < charArray.length; i++){
            char chr = charArray[i];
            buildText = buildText + chr;
            float textCurrX = beginX + textWidth(buildText);
            if(abs(textCurrX - mouseX) < th){
                return i;
            }
        }
        return -1;
    }

    float getCursorX(){
        char[] charArray = text.toCharArray();
        float beginX = getBeginX();

        String buildText = "";
        for(int i = 0; i <= cursor; i++){
            char chr = charArray[i];
            buildText = buildText + chr;
        }
        return beginX + textWidth(buildText);
    }
}

//--------------------------------------------------
class ImageBlock extends Base{
    DrawMode drawMode;
    float x, y, w, h;
    ImageData img;
    

    ImageBlock(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, ImageData imageData, StrokeData strokeData, color fillCol){
        super(splitW, splitH, drawMode, layoutData, strokeData, fillCol);
        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);
        this.x = layoutData.x_point;
        this.y = layoutData.y_point;
        this.w = layoutData.width_point;
        this.h = layoutData.height_point;
        this.img = imageData;
    }
    
    void drawImageBlock(){
        drawBase();
        fill(0, 255, 0);
        if(img.svgTgl){
            drawSVG(x, y, w, h, img.w_scale, img.h_scale, img.scale, img.svg);
        }else{
            drawImage(x, y, w, h, img.w_scale, img.h_scale, img.scale, img.image);
        }
    }
    
    void checkStatus(float mouseX, float mouseY){
        boolean isTouched = isPointInBox(x, y, w, h, mouseX, mouseY);
        if(!hasMouseTouched && isTouched){
            hasMouseTouched = true;
        }
    }
}

//--------------------------------------------------
class Button extends Block{
    DrawMode drawMode;
    StyleData normal, touched, clicked;
    Runnable onClick;
    int colorIndex = -1;
    int status = 0;
    
    Button(int splitW, int splitH, DrawMode drawMode, StyleData normal, StyleData touched, StyleData clicked, Runnable onClick){
        super(splitW, splitH);
        this.drawMode = drawMode;
        this.normal = normal;
        this.touched = touched;
        this.clicked = clicked;
        this.onClick = onClick;
    }
    
    void checkStatus(float mouseX, float mouseY){
        LayoutData normalLayout = normal.layoutData;
        boolean isTouched = isPointInBox(normalLayout.x_point, normalLayout.y_point, normalLayout.width_point, normalLayout.height_point, mouseX, mouseY);
        if(!hasMouseTouched && isTouched){
            if(isMouseLeftClicking){
                status = 2;
                if(onClick != null){
                    onClick.run();
                }else{
                    println(this.onClick);
                }
                isMouseLeftClicking = false;
            }else{
                status = 1;
            }
            hasMouseTouched = true;
        }else{
            status = 0;
        }
    }

    void drawButton(){
        if(status == 2){
            display(clicked);
        }else if(status == 1){
            display(touched);
        }else{
            display(normal);
        }
    }

    void display(StyleData style){
        color fillCol;
        color[] canvasPallet = canvas.colorPallet;
        if(0 <= colorIndex && colorIndex < canvasPallet.length){
            fillCol = canvasPallet[colorIndex];
        }else{
            fillCol = style.fillCol;
        }

        LayoutData layoutData = style.layoutData;
        float x = layoutData.x_point;
        float y = layoutData.y_point;
        float w = layoutData.width_point;
        float h = layoutData.height_point;
        float tl = layoutData.tl_point;
        float tr = layoutData.tr_point;
        float br = layoutData.br_point;
        float bl = layoutData.bl_point;
        
        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);

        ShadowData shadowData = style.shadowData;
        if(shadowData.shadowDistPoint != 0.0 && alpha(shadowData.shadowCol) != 0.0){
            PVector shadowPos = getShadowPos(x, y, shadowData.shadowMode, shadowData.shadowDistPoint);
            fill(shadowData.shadowCol);
            noStroke();
            box(shadowPos.x, shadowPos.y, w, h, tl, tr, br, bl);
        }

        StrokeData strokeData = style.strokeData;
        if(strokeData.strokePoint != 0.0 && alpha(strokeData.strokeCol) != 0.0){
            strokeWeight(getContainerBlockSize(strokeData.strokePoint, strokeData.strokePoint).x);
            stroke(strokeData.strokeCol);
        }else{
            noStroke();
        }
        
        fill(fillCol);
        box(x, y, w, h, tl, tr, br, bl);
        
        ImageData img = style.imageData;
        if(img.svgTgl){
            drawSVG(x, y, w, h, img.w_scale, img.h_scale, img.scale, img.svg);
        }else{
            drawImage(x, y, w, h, img.w_scale, img.h_scale, img.scale, img.image);
        }
    }

    
    PVector getShadowPos(float x, float y, String shadowMode, float shadowDist){
        int calcModeX = 1;
        int calcModeY = 1;
        switch (containerAnker){
            case "topRight" :
                calcModeX = -1;
            break;	
            case "bottomLeft" :
                calcModeY = -1;
            break;	
            case "bottomRight" :
                calcModeX = -1;
                calcModeY = -1;
            break;	
        }
        switch (shadowMode){
            case "BOTTOM" :
                return new PVector(x, y + shadowDist * calcModeY);
            case "TOP" :
                return new PVector(x, y - shadowDist);
            case "RIGHT" :
                return new PVector(x + shadowDist * calcModeX, y);
            case "LEFT" :
                return new PVector(x - shadowDist * calcModeX, y);
            case "BOTTOMRIGHT" :
                return new PVector(x + shadowDist * calcModeX, y + shadowDist * calcModeY);
            case "BOTTOMLEFT" :
                return new PVector(x - shadowDist * calcModeX, y + shadowDist * calcModeY);
            case "TOPRIGHT" :
                return new PVector(x + shadowDist * calcModeX, y - shadowDist * calcModeY);
            case "TOPLEFT" :
                return new PVector(x - shadowDist * calcModeX, y - shadowDist * calcModeY);
            default :
                return new PVector(x, y);
        }
    }
}

//--------------------------------------------------
class Base extends Block{
    DrawMode drawMode;
    color fillCol, strokeCol;
    float x, y, w, h;
    float r, tl, tr, br, bl;
    float strokeW;

    Base(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, StrokeData strokeData, color fillCol){
        super(splitW, splitH);
        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);
        this.drawMode = drawMode;
        this.fillCol = fillCol; 
        this.x = layoutData.x_point;
        this.y = layoutData.y_point;
        this.w = layoutData.width_point;
        this.h = layoutData.height_point;
        this.tl = layoutData.tl_point;
        this.tr = layoutData.tr_point;
        this.br = layoutData.br_point;
        this.bl = layoutData.bl_point;
        this.strokeCol = strokeData.strokeCol;
        this.strokeW = strokeData.strokePoint;
        
    }

    void drawBase(){
        if(alpha(fillCol) == 0.0){
            noFill();
        }else{
            fill(fillCol);
        }
        if(alpha(strokeCol) == 0.0 || strokeW == 0.0){
            noStroke();
        }else{
            stroke(strokeCol);
            float strokeGW = getContainerBlockSize(strokeW, strokeW).y;
            strokeWeight(strokeGW);
        }
        box(x, y, w, h, tl, tr, br, bl);
    }

    void checkStatus(float mouseX, float mouseY){
        boolean isTouched = isPointInBox(x, y, w, h, mouseX, mouseY);
        if(!hasMouseTouched && isTouched && alpha(fillCol) != 0.0){
            hasMouseTouched = true;
        }
    }
}