function ROIdata = manualDrawROI(img,ref_frame, total_frame)
sno = total_frame;
global f_ind, f_indPrev
f_ind = ref_frame;
f_indPrev = [];

BtnSz = 10;
FigPos = get(gcf,'Position');
BtnStPnt = uint16(FigPos(3)-round(FigPos(3)/2))-50;
Btn_Pos = [BtnStPnt 20 100 20];
Btn2_Pos = [BtnStPnt-110 20 100 20];
Btn3_Pos = [BtnStPnt+110 20 100 20];
Btn4_Pos = [BtnStPnt-220 20 100 20];
Btn5_Pos = [BtnStPnt+220 20 100 20];
Btnhand = uicontrol('Style', 'pushbutton','Position', Btn_Pos,'String',...
    'FOR', 'FontSize', BtnSz, 'Callback' , @BacktoFOR);
Btn2hand = uicontrol('Style', 'pushbutton','Position', Btn2_Pos,'String',...
    'Save', 'FontSize', BtnSz, 'Callback' , @ResetROImat);
Btn3hand = uicontrol('Style', 'pushbutton','Position', Btn3_Pos,'String',...
    'Close', 'FontSize', BtnSz, 'Callback' , @ExitGUI);
Btn4hand = uicontrol('Style', 'pushbutton','Position', Btn4_Pos,'String',...
    '<', 'FontSize', BtnSz, 'Callback' , @PreviousFrame);
Btn5hand = uicontrol('Style', 'pushbutton','Position', Btn5_Pos,'String',...
    '>', 'FontSize', BtnSz, 'Callback' , @NextFrame);

set(gcf,'ResizeFcn', @figureResized)
% -=< Figure resize callback function >=-
    function figureResized(object, eventdata)
        FigPos = get(gcf,'Position');
        BtnStPnt = uint16(FigPos(3)-round(FigPos(3)/2))-50;
        if BtnStPnt < 300
            BtnStPnt = 300;
        end
        Btn_Pos = [BtnStPnt 20 100 20];
        Btn_Pos = [BtnStPnt 20 100 20];
        Btn2_Pos = [BtnStPnt-110 20 100 20];
        Btn3_Pos = [BtnStPnt+110 20 100 20];
        Btn4_Pos = [BtnStPnt-220 20 100 20];
        Btn5_Pos = [BtnStPnt+220 20 100 20];
        set(Btnhand,'Position', Btn_Pos);
        set(Btn2hand,'Position', Btn2_Pos);
        set(Btn3hand,'Position', Btn3_Pos);
        set(Btn4hand,'Position', Btn4_Pos);
        set(Btn5hand,'Position', Btn5_Pos);
    end

% -=< Reset ROI for current frame >=-
    function ResetROImat(img,f_ind,ROIdata)
        imshow(img(:,:,f_ind),[])
        hold on
        plot(ROIdata.xp(:,f_ind),ROIdata.yp(:,f_ind))
        ROIdata=drawROI(ROIdata);
    end

% -=< Back to frame of reference (f2p) >=-
    function BacktoFOR(img,ref_frame,ROIdata)
        imshow(img(:,:,ref_frame),[])
        hold on
        plot(ROIdata.xp(:,ref_frame),ROIdata.yp(:,ref_frame))
        f_ind=ref_frame;
    end

% -=< Main function to draw ROI >=-
    function ROIdata = drawROI(ROIdata)
        imshow(img(:,:,f_ind),[])
        hold on
        plot(ROIdata.xp(:,f_ind),ROIdata.yp(:,f_ind))
        ROIdata=drawROI(ROIdata);
    end