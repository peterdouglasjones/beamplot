classdef beamplot < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        TabGroup                     matlab.ui.container.TabGroup
        Tab                          matlab.ui.container.Tab
        OpenBPButton                 matlab.ui.control.Button
        instructionText              matlab.ui.control.TextArea
        Filepathfield                matlab.ui.control.EditField
        HPmodel                      matlab.ui.container.ButtonGroup
        HPmodelHNP0200_1043          matlab.ui.control.RadioButton
        HPmodelHNP0400_1308          matlab.ui.control.RadioButton
        HPmodelHNR0500_1862          matlab.ui.control.RadioButton
        HPmodelHNP0400_1430          matlab.ui.control.RadioButton
        HPmodelHNA0400_1296          matlab.ui.control.RadioButton
        DCBgain                      matlab.ui.container.ButtonGroup
        gainvalhigh                  matlab.ui.control.RadioButton
        gainvallow                   matlab.ui.control.RadioButton
        gainvalnone                  matlab.ui.control.RadioButton
        Label6                       matlab.ui.control.Label
        Label7                       matlab.ui.control.Label
        ColorCheckBox                matlab.ui.control.CheckBox
        BWCheckBox                   matlab.ui.control.CheckBox
        colormapdrop                 matlab.ui.control.DropDown
        IntensitiesCheckBox          matlab.ui.control.CheckBox
        PressuresCheckBox            matlab.ui.control.CheckBox
        NormplotCheckBox             matlab.ui.control.CheckBox
        SurfCheckBox                 matlab.ui.control.CheckBox
        PNGCheckBox                  matlab.ui.control.CheckBox
        TIFFCheckBox                 matlab.ui.control.CheckBox
        FIGcheckbox                  matlab.ui.control.CheckBox
        GeneratePlotButton           matlab.ui.control.Button
        closeallbutton               matlab.ui.control.Button
        LabelNumericEditField        matlab.ui.control.Label
        freq_in_mhz_input            matlab.ui.control.NumericEditField
        Label                        matlab.ui.control.Label
        Xoffsetvar                   matlab.ui.control.NumericEditField
        Label2                       matlab.ui.control.Label
        Yoffsetvar                   matlab.ui.control.NumericEditField
        ContoursLabel_2              matlab.ui.control.Label
        NumContoursField             matlab.ui.control.NumericEditField
        LabelEditField               matlab.ui.control.Label
        GraphTitleField              matlab.ui.control.EditField
        ContoursLabel                matlab.ui.control.Label
        PercentContoursField         matlab.ui.control.NumericEditField
        Tab2                         matlab.ui.container.Tab
        XlinesCheckBox               matlab.ui.control.CheckBox
        YlinesCheckBox2              matlab.ui.control.CheckBox
        Label8                       matlab.ui.control.Label
        Ylinesvar2                   matlab.ui.control.EditField
        ContourplotlinecolorLabel    matlab.ui.control.Label
        contourcolordrop             matlab.ui.control.DropDown
        MaxValuesCheckBox            matlab.ui.control.CheckBox
        LabelEditField2              matlab.ui.control.Label
        Xlinesvar2                   matlab.ui.control.EditField
        IntensityScalingFactorLabel  matlab.ui.control.Label
        IntensityScalingFactor       matlab.ui.control.NumericEditField
        PressureScalingFactorLabel   matlab.ui.control.Label
        PressureScalingFactor        matlab.ui.control.NumericEditField
        SurfaceplotlinecolorLabel    matlab.ui.control.Label
        surflinecolordrop            matlab.ui.control.DropDown
        TracepercentcontourCheckBox  matlab.ui.control.CheckBox
        Tracepercentcontourvalue     matlab.ui.control.NumericEditField
        IntensityEditFieldLabel      matlab.ui.control.Label
        IntensityLimitLow            matlab.ui.control.NumericEditField
        toEditFieldLabel             matlab.ui.control.Label
        IntensityLimitHigh           matlab.ui.control.NumericEditField
        WcmLabel                     matlab.ui.control.Label
        MPaLabel                     matlab.ui.control.Label
        PressureEditFieldLabel       matlab.ui.control.Label
        PressureLimitLow             matlab.ui.control.NumericEditField
        toEditField_2Label           matlab.ui.control.Label
        PressureLimitHigh            matlab.ui.control.NumericEditField
        CustomPlotLimitsCheckBox     matlab.ui.control.CheckBox
        Tab3                         matlab.ui.container.Tab
        TextArea                     matlab.ui.control.TextArea
        TextArea2                    matlab.ui.control.TextArea
    end

    
    %Bugs or action items:
    %If there's no parent folder, program crashes. Check line 339. for example, scan file in the root of a flash drive.
    %Check gainvalnone, for HNA0400 and no preamp, we probably need to incorporate the cable capacitance (104 pF) into...
      % ...the capacitance divider. 0500 doesn't require it because it has the cable permanently attached and is calibrated with it.
    % fix the part on import of values from bmplt, line 650ish, where it takes correct gain values and sets them correctly.
    
    
    
    
    
    methods (Access = private)
        
        function dothesurf = makesurfplot(app,plottype,colormapvar,savePNG,saveTIFF,saveFIG,axis1,axis2,values_to_plot,contours,maxvaluedisp,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
            
            BP_file_path = getappdata(app.UIFigure,'pathname');
            
            figure;
            pause(0.00001);
            frame_h = get(handle(gcf),'JavaFrame');
            set(frame_h,'Maximized',1);
            s = surf(axis2,axis1,values_to_plot,'Facecolor','interp');
            s.EdgeColor = app.surflinecolordrop.Value;
            title(graphtitle,'Interpreter', 'none');
            set(gca,'FontName','Helvetica','FontSize', 20,'LineWidth',2);
            xlabel('mm') % x-axis label
            ylabel('mm') % y-axis label
            set(gcf,'PaperPositionMode','auto')
            
            colorstr = app.colormapdrop.Value;
            axis tight;
            if strcmp(colormapvar,'BW');
                maxval_text_color = 'Black';
                linescolor = 'Black';
                figure_title_temp = strcat(graphtitle,'_BW');
                colormap(flipud(gray));
            else
                figure_title_temp = graphtitle;
                colormap(colorstr);
                if strcmp(colorstr,'jet');
                    maxval_text_color = 'White';
                    linescolor = 'White';
                else
                    maxval_text_color = 'White';
                    linescolor = 'White';
                end
            end
            
            if strcmp(plottype,'I');
%                 if maxvaluedisp;
%                     maxval_text = ['Maximum I (W/cm²) = ',sprintf('%0.2f', maxintensity)];
%                     text(maxval_Xcoord,maxval_Ycoord,maxval_text,'Color',...
%                         maxval_text_color,'FontSize',22);
%                 end
                if app.CustomPlotLimitsCheckBox.Value;
                    maxcolorbar = app.IntensityLimitHigh.Value;
                    mincolorbar = app.IntensityLimitLow.Value;
                    zlim([app.IntensityLimitLow.Value app.IntensityLimitHigh.Value]);
                else
                    maxcolorbar = maxintensity;
                    mincolorbar = 0;
                end
                %maxcb = maxintensity;
                figure_title_tiff = strcat(figure_title_temp,'_Surface','_Intensity.tif');
                figure_title_png = strcat(figure_title_temp,'_Surface','_Intensity.png');
                figure_title_fig = strcat(figure_title_temp,'_Surface','_Intensity.fig');
                if app.IntensityScalingFactor.Value == 1;
                    colorbarlabelstr = 'Intensity (W/cm²)';
                else
                    colorbarlabelstr = strcat('Intensity (W/cm², sf:',num2str(app.IntensityScalingFactor.Value),'x)');
                end
            elseif strcmp(plottype,'P');
%                 if maxvaluedisp;
%                     maxval_text = ['Maximum P (MPa) = ',sprintf('%0.2f', maxpressure)];
%                     text(maxval_Xcoord,maxval_Ycoord,maxval_text,'Color',...
%                         maxval_text_color,'FontSize',22);
%                 end
                maxcb = maxpressure;
                figure_title_tiff = strcat(figure_title_temp,'_Surface','_Pressure.tif');
                figure_title_png = strcat(figure_title_temp,'_Surface','_Pressure.png');
                figure_title_fig = strcat(figure_title_temp,'_Surface','_Pressure.fig');
                if app.PressureScalingFactor.Value == 1;
                    colorbarlabelstr = 'Pressure (MPa)';
                else
                    colorbarlabelstr = strcat('Pressure (MPa, sf:',num2str(app.PressureScalingFactor.Value),'x)');
                end
            elseif strcmp(plottype,'N');
%                 maxval_text = ['Maximum I (W/cm²) = ',sprintf('%0.2f', maxintensity)];
                text(maxval_Xcoord,maxval_Ycoord,maxval_text,'Color',...
                    maxval_text_color,'FontSize',22);
                maxcb = 1;
                figure_title_tiff = strcat(figure_title_temp,'_Surface','_Normalized.tif');
                figure_title_png = strcat(figure_title_temp,'_Surface','_Normalized.png');
                figure_title_fig = strcat(figure_title_temp,'_Surface','_Normalized.fig');
                colorbarlabelstr = 'Normalized';
            end
            
            %getcurrentaxes setup
            if axis2(end)-axis2(1) < 21;
                set(gca,'XTick',[axis2(1):2:axis2(end)]);
            elseif rem(axis2(end)-axis2(1),5) == 0;
                if axis2(end)-axis2(1) < 50;
                    set(gca,'XTick',[axis2(1):5:axis2(end)]);
                end
            end
            if axis1(end)-axis1(1) < 21;
                set(gca,'YTick',[axis1(1):2:axis1(end)]);
            elseif rem(axis1(end)-axis1(1),5) == 0;
                if axis1(end)-axis1(1) < 50;
                    set(gca,'YTick',[axis1(1):5:axis1(end)]);
                end
            end
            
%             %colorbar setup
%             contourvaliter = app.NumContoursField.Value+1;
%             while contourvaliter > 12;
%                 contourvaliter = floor(contourvaliter/2);
%             end    
%             cbstep = maxcb/contourvaliter;
%             cb = colorbar('LineWidth',1);
%             set(cb, 'ylim', [0 maxcb]);
%             set(cb,'ytick',[0:cbstep:maxcb]);
%             newticks=cellfun(@(x)sprintf('%.2f',x),num2cell(get(cb,'ytick')),'Un',0);
%             set(cb,'yticklabel',newticks);
%             cb.Label.String = colorbarlabelstr;
            
            %colorbar setup
            contourvaliter = app.NumContoursField.Value+1;
            while contourvaliter > 12;
                contourvaliter = floor(contourvaliter/2);
            end    
            cbstep = (maxcolorbar-mincolorbar)/contourvaliter;    
            cb = colorbar('LineWidth',1);
            caxis([mincolorbar maxcolorbar]);
            %set(cb, 'ylim', [0 maxcb]);
            set(cb,'ytick',[mincolorbar:cbstep:maxcolorbar]);
            newticks=cellfun(@(x)sprintf('%.2f',x),num2cell(get(cb,'ytick')),'Un',0);
            set(cb,'yticklabel',newticks);
            cb.Label.String = colorbarlabelstr;
            
            
            
            if saveTIFF;
                surf_title_tiff = figure_title_tiff;
                saveas(gca,fullfile(BP_file_path,surf_title_tiff),'tiff');
            end
            if savePNG;
                surf_title_png = figure_title_png;
                saveas(gca,fullfile(BP_file_path,surf_title_png),'png');
            end
            if saveFIG;
                surf_title_fig = figure_title_fig;
                saveas(gca,fullfile(BP_file_path,surf_title_fig),'fig');
            end
            pause(0.4);
        end
        
        function dotheplot = makebeamplot(app,plottype,colormapvar,savePNG,saveTIFF,saveFIG,axis1,axis2,values_to_plot,contours,maxvaluedisp,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
            
            BP_file_path = getappdata(app.UIFigure,'pathname');
            
            maximumvalue = max(max(values_to_plot));
            contourlevelsplus = linspace(0,1,app.NumContoursField.Value+2)*maximumvalue;
            contourlevels = contourlevelsplus(1:end-1);
            numofcolors = app.NumContoursField.Value+1;
            
            if strcmp(app.colormapdrop.Value,'parula')
                colorstr = parula(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'jet')
                colorstr = jet(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'hsv')
                colorstr = hsv(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'hot')
                colorstr = hot(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'cool')
                colorstr = cool(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'spring')
                colorstr = spring(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'summer')
                colorstr = summer(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'autumn')
                colorstr = autumn(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'winter')
                colorstr = winter(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'gray')
                colorstr = gray(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'bone')
                colorstr = bone(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'copper')
                colorstr = copper(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'pink')
                colorstr = pink(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'lines')
                colorstr = lines(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'colorcube')
                colorstr = colorcube(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'prism')
                colorstr = prism(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'flag')
                colorstr = flag(numofcolors);
            elseif strcmp(app.colormapdrop.Value,'white')
                colorstr = white(numofcolors);
            end

            figure;
            pause(0.00001);
            frame_h = get(handle(gcf),'JavaFrame');
            set(frame_h,'Maximized',1);
            contourf(axis2,axis1,values_to_plot,contourlevels,'LineWidth',.5,'LineColor',app.contourcolordrop.Value);
            if app.TracepercentcontourCheckBox.Value;
                hold on
                tracepercentcontour = app.Tracepercentcontourvalue.Value/100*maximumvalue;
                contour(axis2,axis1,values_to_plot,[tracepercentcontour tracepercentcontour],'Linewidth',4,'Linecolor','black','LineStyle',':');
                hold off
            end
           
            
            %colorstr = app.colormapdrop.Value;
            %colorstr = app.contourcolordrop.Value(app.NumContoursField.Value+1);
            %colorstr = parula(10);
            axis equal tight;
            if strcmp(colormapvar,'BW');
                maxval_text_color = 'Black';
                linescolor = 'Black';
                figure_title_temp = strcat(graphtitle,'_BW');
                colormap(flipud(gray));
            else
                figure_title_temp = graphtitle;
                colormap(colorstr);
                if strcmp(colorstr,'jet');
                    maxval_text_color = 'White';
                    linescolor = 'White';
                else
                    maxval_text_color = 'White';
                    linescolor = 'White';
                end
            end
            
            if strcmp(plottype,'I');
                if maxvaluedisp;
                    maxval_text = ['Maximum I (W/cm²) = ',sprintf('%0.2f', maxintensity)];
                    text(maxval_Xcoord,maxval_Ycoord,maxval_text,'Color',...
                        maxval_text_color,'FontSize',22);
                end
                if app.CustomPlotLimitsCheckBox.Value;
                    maxcolorbar = app.IntensityLimitHigh.Value;
                    mincolorbar = app.IntensityLimitLow.Value;
                else
                    maxcolorbar = maxintensity;
                    mincolorbar = 0;
                end
                %maxcb = maxintensity;
                
                figure_title_tiff = strcat(figure_title_temp,'_Intensity.tif');
                figure_title_png = strcat(figure_title_temp,'_Intensity.png');
                figure_title_fig = strcat(figure_title_temp,'_Intensity.fig');
                if app.IntensityScalingFactor.Value == 1;
                    colorbarlabelstr = 'Intensity (W/cm²)';
                else
                    colorbarlabelstr = strcat('Intensity (W/cm², sf:',num2str(app.IntensityScalingFactor.Value),'x)');
                end
            elseif strcmp(plottype,'P');
                if maxvaluedisp;
                    maxval_text = ['Maximum P (MPa) = ',sprintf('%0.2f', maxpressure)];
                    text(maxval_Xcoord,maxval_Ycoord,maxval_text,'Color',...
                        maxval_text_color,'FontSize',22);
                end
                if app.CustomPlotLimitsCheckBox.Value;
                    maxcolorbar = app.PressureLimitHigh.Value;
                    mincolorbar = app.PressureLimitLow.Value;
                else
                    maxcolorbar = maxpressure;
                    mincolorbar = 0;
                end
                %maxcb = maxpressure;
                figure_title_tiff = strcat(figure_title_temp,'_Pressure.tif');
                figure_title_png = strcat(figure_title_temp,'_Pressure.png');
                figure_title_fig = strcat(figure_title_temp,'_Pressure.fig');
                if app.PressureScalingFactor.Value == 1;
                    colorbarlabelstr = 'Pressure (MPa)';
                else
                    colorbarlabelstr = strcat('Pressure (MPa, sf:',num2str(app.PressureScalingFactor.Value),'x)');
                end
            elseif strcmp(plottype,'N');
                maxval_text = ['Maximum I (W/cm²) = ',sprintf('%0.2f', maxintensity)];
                text(maxval_Xcoord,maxval_Ycoord,maxval_text,'Color',...
                    maxval_text_color,'FontSize',22);
                maxcolorbar = 1;
                mincolorbar = 0;
                figure_title_tiff = strcat(figure_title_temp,'_Normalized.tif');
                figure_title_png = strcat(figure_title_temp,'_Normalized.png');
                figure_title_fig = strcat(figure_title_temp,'_Normalized.fig');
                colorbarlabelstr = 'Normalized';
            end
            
            %colorbar setup
            contourvaliter = app.NumContoursField.Value+1;
            while contourvaliter > 12
                contourvaliter = floor(contourvaliter/2);
            end    
            cbstep = (maxcolorbar-mincolorbar)/contourvaliter;    
            cb = colorbar('LineWidth',1);
            caxis([mincolorbar maxcolorbar]);
            %set(cb, 'ylim', [0 maxcb]);
            set(cb,'ytick',[mincolorbar:cbstep:maxcolorbar]);
            newticks=cellfun(@(x)sprintf('%.2f',x),num2cell(get(cb,'ytick')),'Un',0);
            set(cb,'yticklabel',newticks);
            cb.Label.String = colorbarlabelstr;
            
            %getcurrentaxes setup XXXX
            if axis2(end)-axis2(1) < 21
                set(gca,'XTick',[axis2(1):2:axis2(end)]);
            elseif rem(axis2(end)-axis2(1),5) == 0
                if axis2(end)-axis2(1) < 50
                    set(gca,'XTick',[axis2(1):5:axis2(end)]);
                end
            end
            if axis1(end)-axis1(1) < 21
                set(gca,'YTick',[axis1(1):2:axis1(end)]);
            elseif rem(axis1(end)-axis1(1),5) == 0
                if axis1(end)-axis1(1) < 50
                    set(gca,'YTick',[axis1(1):5:axis1(end)]);
                end
            end
            set(gca,'FontName','Helvetica','FontSize', 20,'LineWidth',2);

            title(graphtitle,'Interpreter', 'none');
            xlabel('mm') % x-axis label
            ylabel('mm') % y-axis label
            
            numofxlines = length(xlines);
            i=1;
            while i<=numofxlines
                line([xlines(i) xlines(i)],[axis1(1) axis1(end)],'Color',linescolor,...
                    'LineWidth',1.5,'LineStyle','--');
                i = i+1;
            end
            
            numofylines = length(ylines);
            j=1;
            while j<=numofylines
                line([axis2(1) axis2(end)],[ylines(j) ylines(j)],'Color',linescolor,...
                    'LineWidth',1.5,'LineStyle','--');
                j = j+1;
            end
            
            set(gcf,'PaperPositionMode','auto')
            if saveTIFF
                saveas(gca,fullfile(BP_file_path,figure_title_tiff),'tiff');
            end
            if savePNG
                saveas(gca,fullfile(BP_file_path,figure_title_png),'png');
            end
            if saveFIG
                saveas(gca,fullfile(BP_file_path,figure_title_fig),'fig');
            end
            pause(0.4);
            
         
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
        end

        % Button pushed function: GeneratePlotButton
        function GeneratePlotButtonButtonPushed(app, event)
            relevant_data = getappdata(app.UIFigure,'reldata');
            filename = getappdata(app.UIFigure,'filename');
            
            axis2_temp = relevant_data(1,2:end)';
            axis1_temp = relevant_data(1:end-1,1)';
            vpp2s = relevant_data(2:end,2:end);
            vpp2s = relevant_data(2:end,2:end);
                        
            % XLINES AND YLINES arrays
            if app.XlinesCheckBox.Value
                xlines = str2num(app.Xlinesvar2.Value);
            else
                xlines = [];
            end
            if app.YlinesCheckBox2.Value
                ylines = str2num(app.Ylinesvar2.Value);
            else
                ylines = [];
            end
           
            contours = app.NumContoursField.Value;
            yoffset = app.Yoffsetvar.Value;
            xoffset = app.Xoffsetvar.Value;
            graphtitle = app.GraphTitleField.Value;
            freq_in_mhz = app.freq_in_mhz_input.Value;
            
            %Loads SenslookupHNP0400.txt, SenslookupHNP0200.txt, or
            %SenslookupHNR0500.txt. The text file is 5 tab-delineated columns of
            %values: FREQ_MHZ, SENS_DB, SENS_VPERPA, SENS_V2CM2PERW, and CAP_PF.         
            if app.HPmodelHNR0500_1862.Value;
                hpvals = dlmread('SenslookupHNR0500-1862.txt','',1,0);
                hydrophone_model = 'HNR-0500 [1862]';
            elseif app.HPmodelHNP0400_1308.Value;
                hpvals = dlmread('SenslookupHNP0400-1308.txt','',1,0);
                hydrophone_model = 'HNP-0400 [1308]';
            elseif app.HPmodelHNP0400_1430.Value;
                hpvals = dlmread('SenslookupHNP0400-1430.txt','',1,0);
                hydrophone_model = 'HNP-0400 [1430]';
            elseif app.HPmodelHNP0200_1043.Value;
                hpvals = dlmread('SenslookupHNP0200-1043.txt','',1,0);
                hydrophone_model = 'HNP-0200 [1043]';
            elseif app.HPmodelHNA0400_1296.Value;
                hpvals = dlmread('SenslookupHNA0400-1296.txt','',1,0);
                hydrophone_model = 'HNA-0400 [1296]';
            end
            
            %Ensure query frequency falls within bounds of hydrophone calibration data,
            %if not, set to closest limit frequency.
            if freq_in_mhz < min(hpvals(:,1))
                freq_in_mhz_h = min(hpvals(:,1));
                fprintf(' WARNING: frequency below minimum hydrophone calibration. Using %2.2f MHz.\n', freq_in_mhz_h)
            elseif freq_in_mhz > max(hpvals(:,1))
                freq_in_mhz_h = max(hpvals(:,1));
                fprintf(' WARNING: frequency above maximum hydrophone calibration. Using %2.2f MHz.\n', freq_in_mhz_h)
            else
                freq_in_mhz_h = freq_in_mhz;
            end
            
            %Uses AH2020_senslookup.txt to look up values at freq using interpolation
            %for the DC block and preamp. The text file is 7 tab-delineated columns of
            %values: FREQ_MHZ, GAIN_DBHIGH,	PHASE_DEGHIGH, CAP_PREAMPHIGH, GAIN_DBLOW
            %PHASE_DEGLOW, and CAP_PREAMPLOW.
            pavals = dlmread('SenslookupAH2020.txt','',1,0);
            
            %Ensure query frequency falls within bounds of preamp calibration data,
            %if not, set to closest limit frequency.
            if freq_in_mhz < min(pavals(:,1))
                freq_in_mhz_p = min(pavals(:,1));
                fprintf(' WARNING: frequency below minimum preamp calibration. Using %2.2f MHz.\n', freq_in_mhz_p)
            elseif freq_in_mhz > max(pavals(:,1))
                freq_in_mhz_p = max(pavals(:,1));
                fprintf(' WARNING: frequency above maximum preamp calibration. Using %2.2f MHz.\n', freq_in_mhz_p)
            else
                freq_in_mhz_p = freq_in_mhz;
            end
            
            %Pull CAP_PF and SENS_VPERPA at the frequency specified.
            caphydro = interp1(hpvals(:,1),hpvals(:,5),freq_in_mhz_h,'linear');
            mc = interp1(hpvals(:,1),hpvals(:,3),freq_in_mhz_h,'linear');
            zacoustic=1.5e10; %impedance of water - includes unit correction for cm
            
            %Pull CAP_PREAMP and GAIN_DB for either high, low, or no gain.
            if app.gainvallow.Value
                gaintext = ['Low'];
                capamp = interp1(pavals(:,1),pavals(:,7),freq_in_mhz_p,'linear');
                gaindB = interp1(pavals(:,1),pavals(:,5),freq_in_mhz_p,'linear');
                gain=10.^(gaindB./20); %converting dB to amplitude
                ml=mc.*gain.*caphydro./(caphydro+capamp);
                kcalfactor=zacoustic.*(ml).^2;
            elseif app.gainvalhigh.Value
                gaintext = ['High'];
                capamp = interp1(pavals(:,1),pavals(:,4),freq_in_mhz_p,'linear');
                gaindB = interp1(pavals(:,1),pavals(:,2),freq_in_mhz_p,'linear');
                gain=10.^(gaindB./20); %converting dB to amplitude
                ml=mc.*gain.*caphydro./(caphydro+capamp);
                kcalfactor=zacoustic.*(ml).^2;
            elseif app.gainvalnone.Value
                gaintext = ['No'];
                capamp = interp1(pavals(:,1),pavals(:,4),freq_in_mhz_p,'linear');
                gaindB = interp1(pavals(:,1),pavals(:,2),freq_in_mhz_p,'linear');
                kcalfactor = zacoustic.*(mc).^2;
                ml = mc;
            end
            %For gainvalnone, add if statement for if HNA and none, add in cable capacitance divider
           
            intensities = (app.IntensityScalingFactor.Value).*(vpp2s./(8*kcalfactor));            %convert each Vpp² to I, scale if set to other than 1.
            maxintensity = max(max((intensities)));         %find maximum value
            avgintensity = mean(mean(intensities));         %find average intensity
            total_power = avgintensity*axis1_temp(end)*axis2_temp(end)/100
            pressures = sqrt(intensities*10000*2*1500*1000)/(1e6);  %convert I to MPa
            maxpressure = max(max((pressures)));         %find maximum value
            normalized =  intensities./maxintensity;        %make normalized table
            
            %Generate plots
            axis1 = axis1_temp+yoffset;
            axis2 = axis2_temp+xoffset;
            maxval_Ycoord = axis1(end)-(1/25)*axis1_temp(end);
            maxval_Xcoord = axis2(1)+(1/30)*axis2_temp(end);
            
            warning('off', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame')
            %bpp2(app,app.PressuresCheckBox.Value,app.IntensitiesCheckBox.Value,app.ColorCheckBox.Value,app.BWCheckBox.Value,app.PNGCheckBox.Value,app.TIFFCheckBox.Value,axis1,axis2,intensities,pressures,contours,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
            
            if app.ColorCheckBox.Value
                if app.IntensitiesCheckBox.Value
                    makebeamplot(app,'I','color',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,intensities,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.PressuresCheckBox.Value
                    makebeamplot(app,'P','color',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,pressures,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.NormplotCheckBox.Value
                    makebeamplot(app,'N','color',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,normalized,app.NumContoursField.Value,1,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.SurfCheckBox.Value
                    makesurfplot(app,'I','color',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,intensities,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                    
            end
            if app.BWCheckBox.Value
                if app.IntensitiesCheckBox.Value
                    makebeamplot(app,'I','BW',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,intensities,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.PressuresCheckBox.Value
                    makebeamplot(app,'P','BW',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,pressures,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.NormplotCheckBox.Value
                    makebeamplot(app,'N','BW',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,normalized,app.NumContoursField.Value,1,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.SurfCheckBox.Value
                    makesurfplot(app,'I','BW',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,intensities,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
            end

        end

        % Button pushed function: OpenBPButton
        function OpenBPButtonButtonPushed(app, event)
            persistent parentfolder;
            if isempty(parentfolder)
                [filename, pathname] = uigetfile('*.*', 'Select Plot File', 'MultiSelect', 'off');
                app.UIFigure.Visible = 'off';
                app.UIFigure.Visible = 'on';
                if pathname == 0
                    return
                else
                    idcs = strfind(pathname,'\');
                    if ispc
                        parentfolder = pathname(1:idcs(end-1));
                        % this is current version mac check 2
                    end
                    if ismac
                        parentfolder = pathname;
                    end
                end
            else
                openparent = strcat(parentfolder,'*.*');
                [filename, pathname] = uigetfile(openparent, 'Select Plot File', 'MultiSelect', 'off');
                app.UIFigure.Visible = 'off';
                app.UIFigure.Visible = 'on';
                if pathname == 0
                    return
                else
                    idcs = strfind(pathname,'\');
                    if ispc
                        parentfolder = pathname(1:idcs(end-1));
                    end
                    if ismac
                        parentfolder = pathname;
                    end
                end
                
            end
            
            [~,~,fileext] = fileparts(filename);
            if strcmp(fileext,'.xlsx')
                reldata2 = xlsread(fullfile(pathname,filename)); 
                reldata = transpose(reldata2(3:end,1:end)); %reads voltage data from file (and axis1/axis2 coords)
                reldata(1) = 0;
                Ashft = reldata(1,:)';
                Bshft = circshift(Ashft,length(Ashft)-1)';
                reldata(:,1) = Bshft;
                app.Filepathfield.Value = fullfile(pathname, filename);
                app.instructionText.Value = 'No scan parameters loaded from file, please input manually.';
                app.HPmodelHNP0400_1430.Value = 1;
                app.gainvalhigh.Value = 1;
                set(app.gainvalnone,'enable','off');
                app.Xoffsetvar.Value = 0;
                app.Yoffsetvar.Value = 0;
                app.freq_in_mhz_input.Value = 1;
                app.GraphTitleField.Value = filename(1:end-5);
                setappdata(app.UIFigure,'reldata',reldata);
                setappdata(app.UIFigure,'filename',filename);
                setappdata(app.UIFigure,'pathname',pathname);
            else
                reldata = transpose(dlmread(fullfile(pathname,filename),'',6,0)); %reads voltage data from file (and axis1/axis2 coords)
                app.Filepathfield.Value = fullfile(pathname, filename);
                fid = fopen(fullfile(pathname,filename));
                IDcell = textscan(fid,'%s','Delimiter','\t');
                IDarray = IDcell{1};
                IDarraytrunc = IDarray(1:18);
                fclose(fid);
                
                transducerID = [''];
                if strcmp(IDarraytrunc(3),'')
                    app.instructionText.Value = 'No scan parameters loaded from file, please input manually.';
                    app.HPmodelHNP0400_1430.Value = 1;
                    app.gainvalhigh.Value = 1;
                    set(app.gainvalnone,'enable','off');
                    app.Xoffsetvar.Value = 0;
                    app.Yoffsetvar.Value = 0;
                    app.freq_in_mhz_input.Value = 1;
                    app.GraphTitleField.Value = filename;
                else
                    app.instructionText.Value = 'Scan parameters loaded from file, please verify accuracy.';
                    if strcmp(IDarraytrunc(4),'HNR-0500') || strcmp(IDarraytrunc(4),'HNR-0500 [1862]')
                        %app.HPmodelHNR0500_1862.Value = 1;
                        set(app.HPmodelHNR0500_1862,'value',1);
                        set(app.gainvalnone,'enable','on');
                    elseif strcmp(IDarraytrunc(4),'HNP-0400') || strcmp(IDarraytrunc(4),'HNP-0400 (old)') || strcmp(IDarraytrunc(4),'HNP-0400 [1308]')
                    %elseif strcmp(IDarraytrunc(4),'HNP-0400 (old)');
                        %app.HPmodelHNP0400_1308.Value = 1;
                        set(app.HPmodelHNP0400_1308,'value',1);
                        %app.gainvalhigh.Value = 1;
                        set(app.gainvalnone,'enable','off')
                    elseif strcmp(IDarraytrunc(4),'HNP-0400 (new)') || strcmp(IDarraytrunc(4),'HNP-0400 [1430]')
                        %app.HPmodelHNP0400_1430.Value = 1;
                        set(app.HPmodelHNP0400_1430,'value',1);
                        %app.gainvalhigh.Value = 1;
                        set(app.gainvalnone,'enable','off')
                    elseif strcmp(IDarraytrunc(4),'HNP-0200') || strcmp(IDarraytrunc(4),'HNP-0200 [1043]')
                        %app.HPmodelHNP0200_1043.Value = 1;
                        set(app.HPmodelHNP0200_1043,'value',1);
                        %app.gainvalhigh.Value = 1;
                        set(app.gainvalnone,'enable','off')
                    elseif strcmp(IDarraytrunc(4),'HNA-0400_1296') || strcmp(IDarraytrunc(4),'HNA-0400 [1296]')
                        %app.HPmodelHNP0200_1043.Value = 1;
                        set(app.HPmodelHNA0400_1296,'value',1);
                        %app.gainvalhigh.Value = 1;
                        set(app.gainvalnone,'enable','on')
                    end
                    
                    if strcmp(IDarraytrunc(6),'High')
                        set(app.gainvalhigh,'value',1);
                    elseif strcmp(IDarraytrunc(6),'Low')
                        set(app.gainvallow,'value',1);
                    elseif strcmp(IDarraytrunc(6),'None')
                        set(app.gainvalnone,'value',1);
                    end
                    
                    [filepath,name,ext] = fileparts(filename);
                    
                    app.Xoffsetvar.Value = cellfun(@str2num, IDarraytrunc(18));
                    app.Yoffsetvar.Value = cellfun(@str2num, IDarraytrunc(16));
                    app.freq_in_mhz_input.Value = cellfun(@str2num, IDarraytrunc(10));
                    transducerID = char(IDarraytrunc(2));
                    graphtitlestr = [transducerID,' — ',name];
                    app.GraphTitleField.Value = graphtitlestr;
                end
                
                setappdata(app.UIFigure,'reldata',reldata);
                setappdata(app.UIFigure,'filename',filename);
                setappdata(app.UIFigure,'pathname',pathname);
            end

        end

        % Value changed function: XlinesCheckBox
        function XlinesCheckBoxValueChanged(app, event)
            value = app.XlinesCheckBox.Value;
            if app.XlinesCheckBox.Value
                set(app.Xlinesvar2,'enable','on');
            else
                set(app.Xlinesvar2,'enable','off');
            end
        end

        % Value changed function: YlinesCheckBox2
        function YlinesCheckBox2ValueChanged(app, event)
            value = app.YlinesCheckBox2.Value;
            if app.YlinesCheckBox2.Value
                set(app.Ylinesvar2,'enable','on');
            else
                set(app.Ylinesvar2,'enable','off');
            end            
        end

        % Selection changed function: HPmodel
        function HPmodelSelectionChanged(app, event)
            selectedButton = app.HPmodel.SelectedObject;
            if app.HPmodelHNP0200_1043.Value
                set(app.gainvalnone,'enable','off');
                set(app.gainvalhigh,'enable','on');
                set(app.gainvallow,'enable','on');
                set(app.gainvalhigh,'value',1);
            elseif app.HPmodelHNP0400_1308.Value
                set(app.gainvalnone,'enable','off');
                set(app.gainvalhigh,'enable','on');
                set(app.gainvallow,'enable','on');
                set(app.gainvalhigh,'value',1);
            elseif app.HPmodelHNP0400_1430.Value
                set(app.gainvalnone,'enable','off');
                set(app.gainvalhigh,'enable','on');
                set(app.gainvallow,'enable','on');
                set(app.gainvalhigh,'value',1);
            elseif app.HPmodelHNR0500_1862.Value
                set(app.gainvalnone,'enable','on');
                set(app.gainvalhigh,'enable','off');
                set(app.gainvallow,'enable','off');
                set(app.gainvalnone,'value',1);
            elseif app.HPmodelHNA0400_1296.Value
                set(app.gainvalnone,'enable','on');
                set(app.gainvalhigh,'enable','on');
                set(app.gainvallow,'enable','on');
                set(app.gainvalhigh,'value',1);
            end
            
        end

        % Callback function
        function ColormapFieldValueChanged(app, event)
            colormapvalue = app.ColormapField.Value;
            
        end

        % Value changed function: MaxValuesCheckBox
        function MaxValuesCheckBoxValueChanged(app, event)
            value = app.MaxValuesCheckBox.Value;
            
        end

        % Value changed function: NormplotCheckBox
        function NormplotCheckBoxValueChanged(app, event)
            value = app.NormplotCheckBox.Value;
            
        end

        % Callback function
        function ReadmeButtonPushed(app, event)
%             THIS SECTION COMMENTED OUT BECAUSE README HAS BEEN PUT IN A TAB
%             h = figure;
%             hp = uipanel(h,'Title','Beam Plot Generator Version 1.2, 03/28/18 — Readme','FontSize',12,...
%                 'Position',[0 0 1 1]);
%             btn = uicontrol(h,'Style', 'pushbutton', 'String', 'Close Readme',...
%                 'Position', [18 18 90 36],...
%                 'Callback', @closefigh);
% 
%             readmetextstr = {'Requires lookup tables for the three hydrophones and the preamp.'...
%                 ,''...
%                 'Select "Open File" and choose a raw beam plot output file from Labview. If the file contains scan parameters, they will be loaded automatically and the dialog will confirm.'...
%                 ,''...
%                 '"Offset" will introduce an offset to the axes labeling. For example, if a scan began 10 mm from the transducer, an X offset of 10 will start the graph X-axis at 10 mm. Negative values accepted.'...
%                 ,''...
%                 'Choosing "X lines" or "Y lines" allows drawing of vertical and horizontal lines. Enter values, comma separated, and lines will be printed at that value on the chosen axis.'...
%                 ,''...
%                 'For illustrations of the MATLAB-supported colormaps, see: https://www.mathworks.com/help/matlab/ref/colormap.html'...
%                 ,''...
%                 'Images are saved to the same folder as the beam plot spreadsheet file, and will overwrite older image files without notice.'...
%                 ,''...
%                 };
%                 
%                 readmetext = uicontrol('Style', 'text');
%                 readmetext.Parent = hp;
%                 readmetext.Units = 'normalized';
%                 %align(readmetext,'HorizontalAlignment','Left');
%                 readmetext.Position = [.03    .03    .94    .92];
%                 readmetext.FontSize = 10;
%                 readmetext.String = readmetextstr;
% 
%                 function closefigh(source,event)
%                     close(h);
%                 end
%              
% %                 Code for "advanced options" window in the future
% %                 advwindow = figure;
% %                 advpanel = uipanel
% %                     advpanel.Title = 'Advanced';
% %                     advpanel.BorderType = 'line';
% %                     advpanel.Title = 'Advanced Options';
% %                     advpanel.FontName = 'Helvetica';
% %                     advpanel.FontUnits = 'pixels';
% %                     advpanel.FontSize = 12;
% %                     advpanel.Units = 'normalized';
% %                     advpanel.Position = [0 0 1 1];
            
        end

        % Value changed function: Xlinesvar2
        function ButtonButtonPushed(app, event)
% 
        end

        % Button pushed function: closeallbutton
        function closeallbuttonpush(app, event)
            close all;
        end

        % Value changed function: FIGcheckbox
        function FIGcheckboxValueChanged(app, event)
            value = app.FIGcheckbox.Value;
            
        end

        % Value changed function: SurfCheckBox
        function SurfCheckBoxValueChanged(app, event)
            value = app.SurfCheckBox.Value;
            
        end

        % Value changed function: IntensityScalingFactor
        function IntensityScalingFactorValueChanged(app, event)
            intenscalevalue = app.IntensityScalingFactor.Value;
            app.PressureScalingFactor.Value = sqrt(intenscalevalue);
        end

        % Value changed function: PressureScalingFactor
        function PressureScalingFactorValueChanged(app, event)
            pressscalevalue = app.PressureScalingFactor.Value;
            app.IntensityScalingFactor.Value = pressscalevalue^2;
            
        end

        % Value changed function: NumContoursField
        function NumContoursFieldValueChanged(app, event)
            NumContoursValue = app.NumContoursField.Value;
            app.PercentContoursField.Value = 100/(NumContoursValue+1);
        end

        % Value changed function: PercentContoursField
        function PercentContoursFieldValueChanged(app, event)
            PercentContoursValue = app.PercentContoursField.Value;
            app.NumContoursField.Value = round((100/PercentContoursValue)-1);
            NumContoursValue = app.NumContoursField.Value;
            app.PercentContoursField.Value = 100/(NumContoursValue+1);
        end

        % Value changed function: Tracepercentcontourvalue
        function TracepercentcontourvalueValueChanged(app, event)
            value = app.Tracepercentcontourvalue.Value;
            
        end

        % Value changed function: TracepercentcontourCheckBox
        function TracepercentcontourCheckBoxValueChanged(app, event)
            value = app.TracepercentcontourCheckBox.Value;
            if app.TracepercentcontourCheckBox.Value;
                set(app.Tracepercentcontourvalue,'enable','on');
            else
                set(app.Tracepercentcontourvalue,'enable','off');
            end  
        end

        % Value changed function: CustomPlotLimitsCheckBox
        function CustomPlotLimitsCheckBoxValueChanged(app, event)
            value = app.CustomPlotLimitsCheckBox.Value;
            if app.CustomPlotLimitsCheckBox.Value;
                set(app.IntensityLimitLow,'enable','on');
                set(app.IntensityLimitHigh,'enable','on');
                set(app.PressureLimitLow,'enable','on');
                set(app.PressureLimitHigh,'enable','on');
            else
                app.IntensityLimitLow.Value = 0;
                app.IntensityLimitHigh.Value = 1;
                app.PressureLimitLow.Value = 0;
                app.PressureLimitHigh.Value = 0.1732;
                set(app.IntensityLimitLow,'enable','off');
                set(app.IntensityLimitHigh,'enable','off');
                set(app.PressureLimitLow,'enable','off');
                set(app.PressureLimitHigh,'enable','off');
            end  
        end

        % Value changed function: IntensityLimitLow
        function IntensityLimitLowValueChanged(app, event)
            IntensityLimitLow = app.IntensityLimitLow.Value;
            app.PressureLimitLow.Value = sqrt(IntensityLimitLow.*(10000*2*1500*1000))./(1e6);
        end

        % Value changed function: IntensityLimitHigh
        function IntensityLimitHighValueChanged(app, event)
            IntensityLimitHigh = app.IntensityLimitHigh.Value;
            app.PressureLimitHigh.Value = sqrt(IntensityLimitHigh.*(10000*2*1500*1000))./(1e6);
        end

        % Value changed function: PressureLimitLow
        function PressureLimitLowValueChanged(app, event)
            PressureLimitLow = app.PressureLimitLow.Value;
            app.IntensityLimitLow.Value = ((PressureLimitLow*1e6).^2)/(10000*2*1500*1000);
        end

        % Value changed function: PressureLimitHigh
        function PressureLimitHighValueChanged(app, event)
            PressureLimitHigh = app.PressureLimitHigh.Value;
            app.IntensityLimitHigh.Value = ((PressureLimitHigh*1e6).^2)/(10000*2*1500*1000);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [101 101 573 657];
            app.UIFigure.Name = 'Beam Plot Generator v1.6.4';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 573 657];

            % Create Tab
            app.Tab = uitab(app.TabGroup);
            app.Tab.Title = 'Beam Plot';

            % Create OpenBPButton
            app.OpenBPButton = uibutton(app.Tab, 'push');
            app.OpenBPButton.ButtonPushedFcn = createCallbackFcn(app, @OpenBPButtonButtonPushed, true);
            app.OpenBPButton.Position = [19 554 77 22];
            app.OpenBPButton.Text = 'Open File';

            % Create instructionText
            app.instructionText = uitextarea(app.Tab);
            app.instructionText.Editable = 'off';
            app.instructionText.HorizontalAlignment = 'center';
            app.instructionText.FontSize = 14;
            app.instructionText.BackgroundColor = [0.9373 0.9373 0.9373];
            app.instructionText.Position = [48 591 479 25];
            app.instructionText.Value = {'     Select beam plot file.   '};

            % Create Filepathfield
            app.Filepathfield = uieditfield(app.Tab, 'text');
            app.Filepathfield.Editable = 'off';
            app.Filepathfield.Position = [110 554 429 22];

            % Create HPmodel
            app.HPmodel = uibuttongroup(app.Tab);
            app.HPmodel.SelectionChangedFcn = createCallbackFcn(app, @HPmodelSelectionChanged, true);
            app.HPmodel.Title = 'Hydrophone model, S/N';
            app.HPmodel.Position = [229 384 149 145];

            % Create HPmodelHNP0200_1043
            app.HPmodelHNP0200_1043 = uiradiobutton(app.HPmodel);
            app.HPmodelHNP0200_1043.Text = 'HNP-0200 [1043]';
            app.HPmodelHNP0200_1043.Position = [11 96 115 22];

            % Create HPmodelHNP0400_1308
            app.HPmodelHNP0400_1308 = uiradiobutton(app.HPmodel);
            app.HPmodelHNP0400_1308.Text = 'HNP-0400 [1308]';
            app.HPmodelHNP0400_1308.Position = [11 74 115 22];

            % Create HPmodelHNR0500_1862
            app.HPmodelHNR0500_1862 = uiradiobutton(app.HPmodel);
            app.HPmodelHNR0500_1862.Text = 'HNR-0500 [1862]';
            app.HPmodelHNR0500_1862.Position = [11 7 115 22];
            app.HPmodelHNR0500_1862.Value = true;

            % Create HPmodelHNP0400_1430
            app.HPmodelHNP0400_1430 = uiradiobutton(app.HPmodel);
            app.HPmodelHNP0400_1430.Text = 'HNP-0400 [1430]';
            app.HPmodelHNP0400_1430.Position = [11 51 115 22];

            % Create HPmodelHNA0400_1296
            app.HPmodelHNA0400_1296 = uiradiobutton(app.HPmodel);
            app.HPmodelHNA0400_1296.Text = 'HNA-0400 [1296]';
            app.HPmodelHNA0400_1296.Position = [11 29 115 22];

            % Create DCBgain
            app.DCBgain = uibuttongroup(app.Tab);
            app.DCBgain.Title = 'DC Block Gain';
            app.DCBgain.Position = [390 401 123 106];

            % Create gainvalhigh
            app.gainvalhigh = uiradiobutton(app.DCBgain);
            app.gainvalhigh.Text = 'High';
            app.gainvalhigh.Position = [11 60 45 16];

            % Create gainvallow
            app.gainvallow = uiradiobutton(app.DCBgain);
            app.gainvallow.Text = 'Low';
            app.gainvallow.Position = [11 38 42 16];

            % Create gainvalnone
            app.gainvalnone = uiradiobutton(app.DCBgain);
            app.gainvalnone.Text = 'None';
            app.gainvalnone.Position = [11 16 49 16];
            app.gainvalnone.Value = true;

            % Create Label6
            app.Label6 = uilabel(app.Tab);
            app.Label6.VerticalAlignment = 'top';
            app.Label6.FontSize = 14;
            app.Label6.FontWeight = 'bold';
            app.Label6.Position = [67 513 119 18];
            app.Label6.Text = 'Scan Parameters:';

            % Create Label7
            app.Label7 = uilabel(app.Tab);
            app.Label7.VerticalAlignment = 'top';
            app.Label7.FontSize = 14;
            app.Label7.FontWeight = 'bold';
            app.Label7.Position = [74 355 106 18];
            app.Label7.Text = 'Graph Options:';

            % Create ColorCheckBox
            app.ColorCheckBox = uicheckbox(app.Tab);
            app.ColorCheckBox.Text = 'Color:';
            app.ColorCheckBox.Position = [111 256 52 16];
            app.ColorCheckBox.Value = true;

            % Create BWCheckBox
            app.BWCheckBox = uicheckbox(app.Tab);
            app.BWCheckBox.Text = 'Black and white';
            app.BWCheckBox.Position = [111 226 105 16];

            % Create colormapdrop
            app.colormapdrop = uidropdown(app.Tab);
            app.colormapdrop.Items = {'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', 'copper', 'pink', 'lines', 'colorcube', 'prism', 'flag', 'white'};
            app.colormapdrop.FontSize = 10;
            app.colormapdrop.BackgroundColor = [1 1 1];
            app.colormapdrop.Position = [169 254 48 20];
            app.colormapdrop.Value = 'parula';

            % Create IntensitiesCheckBox
            app.IntensitiesCheckBox = uicheckbox(app.Tab);
            app.IntensitiesCheckBox.Text = 'Intensity Plot';
            app.IntensitiesCheckBox.Position = [254 316 88 16];
            app.IntensitiesCheckBox.Value = true;

            % Create PressuresCheckBox
            app.PressuresCheckBox = uicheckbox(app.Tab);
            app.PressuresCheckBox.Text = 'Pressure Plot';
            app.PressuresCheckBox.Position = [254 286 92 16];

            % Create NormplotCheckBox
            app.NormplotCheckBox = uicheckbox(app.Tab);
            app.NormplotCheckBox.ValueChangedFcn = createCallbackFcn(app, @NormplotCheckBoxValueChanged, true);
            app.NormplotCheckBox.Text = 'Normalized Plot';
            app.NormplotCheckBox.Position = [254 256 106 16];

            % Create SurfCheckBox
            app.SurfCheckBox = uicheckbox(app.Tab);
            app.SurfCheckBox.ValueChangedFcn = createCallbackFcn(app, @SurfCheckBoxValueChanged, true);
            app.SurfCheckBox.Text = '3D Surface I Plot';
            app.SurfCheckBox.Position = [254 226 110 16];

            % Create PNGCheckBox
            app.PNGCheckBox = uicheckbox(app.Tab);
            app.PNGCheckBox.Text = 'Save .PNGs';
            app.PNGCheckBox.Position = [392 286 85 16];
            app.PNGCheckBox.Value = true;

            % Create TIFFCheckBox
            app.TIFFCheckBox = uicheckbox(app.Tab);
            app.TIFFCheckBox.Text = 'Save .TIFFs';
            app.TIFFCheckBox.Position = [392 256 83 16];

            % Create FIGcheckbox
            app.FIGcheckbox = uicheckbox(app.Tab);
            app.FIGcheckbox.ValueChangedFcn = createCallbackFcn(app, @FIGcheckboxValueChanged, true);
            app.FIGcheckbox.Text = 'Save .FIGs';
            app.FIGcheckbox.Position = [392 316 78 16];
            app.FIGcheckbox.Value = true;

            % Create GeneratePlotButton
            app.GeneratePlotButton = uibutton(app.Tab, 'push');
            app.GeneratePlotButton.ButtonPushedFcn = createCallbackFcn(app, @GeneratePlotButtonButtonPushed, true);
            app.GeneratePlotButton.BackgroundColor = [0.9373 0.9373 0.9373];
            app.GeneratePlotButton.FontWeight = 'bold';
            app.GeneratePlotButton.Position = [221 102 138 47];
            app.GeneratePlotButton.Text = 'Generate Plot';

            % Create closeallbutton
            app.closeallbutton = uibutton(app.Tab, 'push');
            app.closeallbutton.ButtonPushedFcn = createCallbackFcn(app, @closeallbuttonpush, true);
            app.closeallbutton.FontSize = 11;
            app.closeallbutton.FontAngle = 'italic';
            app.closeallbutton.Position = [246 18 87 22];
            app.closeallbutton.Text = 'Close all figures';

            % Create LabelNumericEditField
            app.LabelNumericEditField = uilabel(app.Tab);
            app.LabelNumericEditField.HorizontalAlignment = 'right';
            app.LabelNumericEditField.VerticalAlignment = 'top';
            app.LabelNumericEditField.Position = [55 479 94 15];
            app.LabelNumericEditField.Text = 'Frequency (MHz)';

            % Create freq_in_mhz_input
            app.freq_in_mhz_input = uieditfield(app.Tab, 'numeric');
            app.freq_in_mhz_input.Limits = [0 50];
            app.freq_in_mhz_input.ValueDisplayFormat = '%.2f';
            app.freq_in_mhz_input.Position = [166 475 46 22];
            app.freq_in_mhz_input.Value = 1;

            % Create Label
            app.Label = uilabel(app.Tab);
            app.Label.HorizontalAlignment = 'right';
            app.Label.VerticalAlignment = 'top';
            app.Label.Position = [39 444 110 15];
            app.Label.Text = 'X-axis offset (mm)';

            % Create Xoffsetvar
            app.Xoffsetvar = uieditfield(app.Tab, 'numeric');
            app.Xoffsetvar.Limits = [-500 500];
            app.Xoffsetvar.Position = [166 440 46 22];

            % Create Label2
            app.Label2 = uilabel(app.Tab);
            app.Label2.HorizontalAlignment = 'right';
            app.Label2.VerticalAlignment = 'top';
            app.Label2.Position = [39 410 110 15];
            app.Label2.Text = 'Y-axis offset (mm)';

            % Create Yoffsetvar
            app.Yoffsetvar = uieditfield(app.Tab, 'numeric');
            app.Yoffsetvar.Limits = [-500 500];
            app.Yoffsetvar.Position = [166 406 46 22];

            % Create ContoursLabel_2
            app.ContoursLabel_2 = uilabel(app.Tab);
            app.ContoursLabel_2.HorizontalAlignment = 'right';
            app.ContoursLabel_2.VerticalAlignment = 'top';
            app.ContoursLabel_2.Position = [95 311 68 22];
            app.ContoursLabel_2.Text = '# Contours:';

            % Create NumContoursField
            app.NumContoursField = uieditfield(app.Tab, 'numeric');
            app.NumContoursField.Limits = [0 500];
            app.NumContoursField.ValueChangedFcn = createCallbackFcn(app, @NumContoursFieldValueChanged, true);
            app.NumContoursField.Position = [169 314 48 22];
            app.NumContoursField.Value = 9;

            % Create LabelEditField
            app.LabelEditField = uilabel(app.Tab);
            app.LabelEditField.HorizontalAlignment = 'right';
            app.LabelEditField.VerticalAlignment = 'top';
            app.LabelEditField.Position = [20 178 152 15];
            app.LabelEditField.Text = 'Edit Filename and Plot Title:';

            % Create GraphTitleField
            app.GraphTitleField = uieditfield(app.Tab, 'text');
            app.GraphTitleField.Position = [179 174 360 22];

            % Create ContoursLabel
            app.ContoursLabel = uilabel(app.Tab);
            app.ContoursLabel.HorizontalAlignment = 'right';
            app.ContoursLabel.VerticalAlignment = 'top';
            app.ContoursLabel.Position = [91 280 72 22];
            app.ContoursLabel.Text = '% Contours:';

            % Create PercentContoursField
            app.PercentContoursField = uieditfield(app.Tab, 'numeric');
            app.PercentContoursField.Limits = [0 500];
            app.PercentContoursField.ValueChangedFcn = createCallbackFcn(app, @PercentContoursFieldValueChanged, true);
            app.PercentContoursField.Position = [169 283 48 22];
            app.PercentContoursField.Value = 10;

            % Create Tab2
            app.Tab2 = uitab(app.TabGroup);
            app.Tab2.Title = 'Settings';

            % Create XlinesCheckBox
            app.XlinesCheckBox = uicheckbox(app.Tab2);
            app.XlinesCheckBox.ValueChangedFcn = createCallbackFcn(app, @XlinesCheckBoxValueChanged, true);
            app.XlinesCheckBox.Text = '';
            app.XlinesCheckBox.Position = [53 545 22 16];

            % Create YlinesCheckBox2
            app.YlinesCheckBox2 = uicheckbox(app.Tab2);
            app.YlinesCheckBox2.ValueChangedFcn = createCallbackFcn(app, @YlinesCheckBox2ValueChanged, true);
            app.YlinesCheckBox2.Text = '';
            app.YlinesCheckBox2.Position = [53 513 22 16];

            % Create Label8
            app.Label8 = uilabel(app.Tab2);
            app.Label8.HorizontalAlignment = 'right';
            app.Label8.VerticalAlignment = 'top';
            app.Label8.Position = [62 514 162 15];
            app.Label8.Text = 'Draw lines at Y-axis Values:';

            % Create Ylinesvar2
            app.Ylinesvar2 = uieditfield(app.Tab2, 'text');
            app.Ylinesvar2.Enable = 'off';
            app.Ylinesvar2.Position = [231 510 61 22];
            app.Ylinesvar2.Value = '0';

            % Create ContourplotlinecolorLabel
            app.ContourplotlinecolorLabel = uilabel(app.Tab2);
            app.ContourplotlinecolorLabel.HorizontalAlignment = 'right';
            app.ContourplotlinecolorLabel.VerticalAlignment = 'top';
            app.ContourplotlinecolorLabel.Position = [47 346 126 22];
            app.ContourplotlinecolorLabel.Text = 'Contour plot line color:';

            % Create contourcolordrop
            app.contourcolordrop = uidropdown(app.Tab2);
            app.contourcolordrop.Items = {'Black', 'White', 'None'};
            app.contourcolordrop.FontSize = 10;
            app.contourcolordrop.BackgroundColor = [1 1 1];
            app.contourcolordrop.Position = [184 350 71 20];
            app.contourcolordrop.Value = 'Black';

            % Create MaxValuesCheckBox
            app.MaxValuesCheckBox = uicheckbox(app.Tab2);
            app.MaxValuesCheckBox.ValueChangedFcn = createCallbackFcn(app, @MaxValuesCheckBoxValueChanged, true);
            app.MaxValuesCheckBox.Text = '  Print Maximum Values on Plots';
            app.MaxValuesCheckBox.Position = [53 449 196 22];

            % Create LabelEditField2
            app.LabelEditField2 = uilabel(app.Tab2);
            app.LabelEditField2.HorizontalAlignment = 'right';
            app.LabelEditField2.VerticalAlignment = 'top';
            app.LabelEditField2.Position = [62 546 162 15];
            app.LabelEditField2.Text = 'Draw lines at X-axis Values:';

            % Create Xlinesvar2
            app.Xlinesvar2 = uieditfield(app.Tab2, 'text');
            app.Xlinesvar2.ValueChangedFcn = createCallbackFcn(app, @ButtonButtonPushed, true);
            app.Xlinesvar2.Enable = 'off';
            app.Xlinesvar2.Position = [231 542 61 22];
            app.Xlinesvar2.Value = '0';

            % Create IntensityScalingFactorLabel
            app.IntensityScalingFactorLabel = uilabel(app.Tab2);
            app.IntensityScalingFactorLabel.HorizontalAlignment = 'right';
            app.IntensityScalingFactorLabel.Position = [47 415 134 22];
            app.IntensityScalingFactorLabel.Text = 'Intensity Scaling Factor:';

            % Create IntensityScalingFactor
            app.IntensityScalingFactor = uieditfield(app.Tab2, 'numeric');
            app.IntensityScalingFactor.ValueChangedFcn = createCallbackFcn(app, @IntensityScalingFactorValueChanged, true);
            app.IntensityScalingFactor.Position = [192 415 39 22];
            app.IntensityScalingFactor.Value = 1;

            % Create PressureScalingFactorLabel
            app.PressureScalingFactorLabel = uilabel(app.Tab2);
            app.PressureScalingFactorLabel.HorizontalAlignment = 'right';
            app.PressureScalingFactorLabel.Position = [47 383 137 22];
            app.PressureScalingFactorLabel.Text = 'Pressure Scaling Factor:';

            % Create PressureScalingFactor
            app.PressureScalingFactor = uieditfield(app.Tab2, 'numeric');
            app.PressureScalingFactor.ValueChangedFcn = createCallbackFcn(app, @PressureScalingFactorValueChanged, true);
            app.PressureScalingFactor.Position = [192 383 39 22];
            app.PressureScalingFactor.Value = 1;

            % Create SurfaceplotlinecolorLabel
            app.SurfaceplotlinecolorLabel = uilabel(app.Tab2);
            app.SurfaceplotlinecolorLabel.HorizontalAlignment = 'right';
            app.SurfaceplotlinecolorLabel.VerticalAlignment = 'top';
            app.SurfaceplotlinecolorLabel.Position = [48 314 124 22];
            app.SurfaceplotlinecolorLabel.Text = 'Surface plot line color:';

            % Create surflinecolordrop
            app.surflinecolordrop = uidropdown(app.Tab2);
            app.surflinecolordrop.Items = {'Black', 'White', 'None'};
            app.surflinecolordrop.FontSize = 10;
            app.surflinecolordrop.BackgroundColor = [1 1 1];
            app.surflinecolordrop.Position = [184 318 71 20];
            app.surflinecolordrop.Value = 'Black';

            % Create TracepercentcontourCheckBox
            app.TracepercentcontourCheckBox = uicheckbox(app.Tab2);
            app.TracepercentcontourCheckBox.ValueChangedFcn = createCallbackFcn(app, @TracepercentcontourCheckBoxValueChanged, true);
            app.TracepercentcontourCheckBox.Text = '  Trace          % contour';
            app.TracepercentcontourCheckBox.Position = [53 480 146 22];

            % Create Tracepercentcontourvalue
            app.Tracepercentcontourvalue = uieditfield(app.Tab2, 'numeric');
            app.Tracepercentcontourvalue.ValueChangedFcn = createCallbackFcn(app, @TracepercentcontourvalueValueChanged, true);
            app.Tracepercentcontourvalue.Enable = 'off';
            app.Tracepercentcontourvalue.Position = [112 480 28 22];
            app.Tracepercentcontourvalue.Value = 50;

            % Create IntensityEditFieldLabel
            app.IntensityEditFieldLabel = uilabel(app.Tab2);
            app.IntensityEditFieldLabel.HorizontalAlignment = 'right';
            app.IntensityEditFieldLabel.Position = [69 257 54 22];
            app.IntensityEditFieldLabel.Text = 'Intensity:';

            % Create IntensityLimitLow
            app.IntensityLimitLow = uieditfield(app.Tab2, 'numeric');
            app.IntensityLimitLow.ValueChangedFcn = createCallbackFcn(app, @IntensityLimitLowValueChanged, true);
            app.IntensityLimitLow.Enable = 'off';
            app.IntensityLimitLow.Position = [134 257 54 22];

            % Create toEditFieldLabel
            app.toEditFieldLabel = uilabel(app.Tab2);
            app.toEditFieldLabel.HorizontalAlignment = 'right';
            app.toEditFieldLabel.Position = [180 257 24 22];
            app.toEditFieldLabel.Text = 'to';

            % Create IntensityLimitHigh
            app.IntensityLimitHigh = uieditfield(app.Tab2, 'numeric');
            app.IntensityLimitHigh.ValueChangedFcn = createCallbackFcn(app, @IntensityLimitHighValueChanged, true);
            app.IntensityLimitHigh.Enable = 'off';
            app.IntensityLimitHigh.Position = [212 257 54 22];
            app.IntensityLimitHigh.Value = 1;

            % Create WcmLabel
            app.WcmLabel = uilabel(app.Tab2);
            app.WcmLabel.Position = [276 257 40 22];
            app.WcmLabel.Text = 'W/cm²';

            % Create MPaLabel
            app.MPaLabel = uilabel(app.Tab2);
            app.MPaLabel.Position = [276 228 30 22];
            app.MPaLabel.Text = 'MPa';

            % Create PressureEditFieldLabel
            app.PressureEditFieldLabel = uilabel(app.Tab2);
            app.PressureEditFieldLabel.HorizontalAlignment = 'right';
            app.PressureEditFieldLabel.Position = [69 228 57 22];
            app.PressureEditFieldLabel.Text = 'Pressure:';

            % Create PressureLimitLow
            app.PressureLimitLow = uieditfield(app.Tab2, 'numeric');
            app.PressureLimitLow.ValueChangedFcn = createCallbackFcn(app, @PressureLimitLowValueChanged, true);
            app.PressureLimitLow.Enable = 'off';
            app.PressureLimitLow.Position = [134 228 54 22];

            % Create toEditField_2Label
            app.toEditField_2Label = uilabel(app.Tab2);
            app.toEditField_2Label.HorizontalAlignment = 'right';
            app.toEditField_2Label.Position = [179 228 25 22];
            app.toEditField_2Label.Text = 'to';

            % Create PressureLimitHigh
            app.PressureLimitHigh = uieditfield(app.Tab2, 'numeric');
            app.PressureLimitHigh.ValueChangedFcn = createCallbackFcn(app, @PressureLimitHighValueChanged, true);
            app.PressureLimitHigh.Enable = 'off';
            app.PressureLimitHigh.Position = [212 228 54 22];
            app.PressureLimitHigh.Value = 0.1732;

            % Create CustomPlotLimitsCheckBox
            app.CustomPlotLimitsCheckBox = uicheckbox(app.Tab2);
            app.CustomPlotLimitsCheckBox.ValueChangedFcn = createCallbackFcn(app, @CustomPlotLimitsCheckBoxValueChanged, true);
            app.CustomPlotLimitsCheckBox.Text = ' Custom Plot Limits:';
            app.CustomPlotLimitsCheckBox.Position = [53 283 129 22];

            % Create Tab3
            app.Tab3 = uitab(app.TabGroup);
            app.Tab3.Title = 'Readme';

            % Create TextArea
            app.TextArea = uitextarea(app.Tab3);
            app.TextArea.BackgroundColor = [0.9373 0.9373 0.9373];
            app.TextArea.Position = [1 2 571 596];
            app.TextArea.Value = {'Requires 6 lookup tables (five hydrophones and the preamp).'; ''; 'Select "Open File" and choose a beam plot output file from Labview (.bmplt). If the file contains scan '; 'parameters, they will be loaded automatically and the dialog will confirm. Cannot open files from a root directory (i.e. directly on a flash drive, must be in a folder).'; ''; '"Offset" will introduce an offset to the axes labeling. For example, if a scan began 10 mm from the '; 'transducer, an X offset of 10 will start the graph X-axis at 10 mm. Negative values accepted.'; ''; 'Choosing "X lines" or "Y lines" allows drawing of vertical and horizontal lines. Enter values, comma '; 'separated, and lines will be printed at that value on the chosen axis.'; ''; 'Custom plot limit examples:'; ' - Set max value just under the absolute maximum across all plots you want to compare. For example, if the maximum intensity across 5 different plots is 5.87 W/cm², set custom max to 5.86 to ensure you catch the high value, and then all 5 plots will have color-coordinated contours for direct comparison.'; ' - Set max value low to highlight all areas above that value. For example, set the maximum limit to 1 W/cm² and everything above that will be colored in the highest value.'; ''; 'For illustrations of the MATLAB-supported colormaps, see: '; 'https://www.mathworks.com/help/matlab/ref/colormap.html'; ''; 'WARNING: Images are saved to the same folder where the beam plot spreadsheet file was opened from, and will overwrite older image files without notice.'; ''; '"Scaling Factor" is a multiplier for hydrophones with known calibration offsets. If a hydrophone undervalues intensity by half, a 2 factor will double reported/plotted values.'; ''; ''; ''; ''; 'Changelog:'; 'v1.4: Added custom scaling input for hydrophone correction, fixed surface plotting (open figure and correct scaling).'; ''; 'v1.5: Generates all contours correctly, color is filled correctly. Now traces any % contour.'; ''; 'v1.6: Arbitrary graph limits added for direct comparisons. All colormaps supported. Needs Psurf. 1.6.1 Fixed norm plots. 1.6.2 Added new HNA0400[1296] hydrophone. 1.6.3 Added SNs for all hydrophones to integrate with new Labview code. 1.6.4 Renamed lookup tables.'};

            % Create TextArea2
            app.TextArea2 = uitextarea(app.Tab3);
            app.TextArea2.FontSize = 14;
            app.TextArea2.FontWeight = 'bold';
            app.TextArea2.BackgroundColor = [0.9373 0.9373 0.9373];
            app.TextArea2.Position = [1 597 571 39];
            app.TextArea2.Value = {'Version 1.6.4 - 05/26/21'};

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = beamplot

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end