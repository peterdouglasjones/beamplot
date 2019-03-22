classdef beamplot_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        TabGroup               matlab.ui.container.TabGroup
        Tab                    matlab.ui.container.Tab
        OpenBPButton           matlab.ui.control.Button
        instructionText        matlab.ui.control.TextArea
        Filepathfield          matlab.ui.control.EditField
        HPmodel                matlab.ui.container.ButtonGroup
        HPmodel0200            matlab.ui.control.RadioButton
        HPmodel0400old         matlab.ui.control.RadioButton
        HPmodel0500            matlab.ui.control.RadioButton
        HPmodel0400new         matlab.ui.control.RadioButton
        DCBgain                matlab.ui.container.ButtonGroup
        gainvalhigh            matlab.ui.control.RadioButton
        gainvallow             matlab.ui.control.RadioButton
        gainvalnone            matlab.ui.control.RadioButton
        Label6                 matlab.ui.control.Label
        Label7                 matlab.ui.control.Label
        ColorCheckBox          matlab.ui.control.CheckBox
        BWCheckBox             matlab.ui.control.CheckBox
        colormapdrop           matlab.ui.control.DropDown
        IntensitiesCheckBox    matlab.ui.control.CheckBox
        PressuresCheckBox      matlab.ui.control.CheckBox
        NormplotCheckBox       matlab.ui.control.CheckBox
        SurfCheckBox           matlab.ui.control.CheckBox
        PNGCheckBox            matlab.ui.control.CheckBox
        TIFFCheckBox           matlab.ui.control.CheckBox
        FIGcheckbox            matlab.ui.control.CheckBox
        GeneratePlotButton     matlab.ui.control.Button
        closeallbutton         matlab.ui.control.Button
        LabelNumericEditField  matlab.ui.control.Label
        freq_in_mhz_input      matlab.ui.control.NumericEditField
        Label                  matlab.ui.control.Label
        Xoffsetvar             matlab.ui.control.NumericEditField
        Label2                 matlab.ui.control.Label
        Yoffsetvar             matlab.ui.control.NumericEditField
        Label5                 matlab.ui.control.Label
        NumContoursField       matlab.ui.control.NumericEditField
        LabelEditField         matlab.ui.control.Label
        GraphTitleField        matlab.ui.control.EditField
        Tab2                   matlab.ui.container.Tab
        XlinesCheckBox         matlab.ui.control.CheckBox
        YlinesCheckBox2        matlab.ui.control.CheckBox
        Label8                 matlab.ui.control.Label
        Ylinesvar2             matlab.ui.control.EditField
        LabelDropDown          matlab.ui.control.Label
        contourcolordrop       matlab.ui.control.DropDown
        MaxValuesCheckBox      matlab.ui.control.CheckBox
        LabelEditField2        matlab.ui.control.Label
        Xlinesvar2             matlab.ui.control.EditField
        Tab3                   matlab.ui.container.Tab
        TextArea               matlab.ui.control.TextArea
        TextArea2              matlab.ui.control.TextArea
    end

    
    %Bugs or action items:
    %If there's no parent folder, program crashes. Check line 339. for example, scan file in the root of a flash drive.
    
    
    
    
    
    
    methods (Access = private)
        
        function dothesurf = makesurfplot(app,plottype,colormapvar,savePNG,saveTIFF,saveFIG,axis1,axis2,values_to_plot,contours,maxvaluedisp,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
            
            BP_file_path = getappdata(app.UIFigure,'pathname');
            
            s = surf(axis2,axis1,values_to_plot);
            s.EdgeColor = app.contourcolordrop.Value;
            title(graphtitle,'Interpreter', 'none');
            set(gca,'FontName','Helvetica','FontSize', 20,'LineWidth',2);
            xlabel('mm') % x-axis label
            ylabel('mm') % y-axis label
            set(gcf,'PaperPositionMode','auto')
            
            colorstr = app.colormapdrop.Value;
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
                maxcb = maxintensity;
                figure_title_tiff = strcat(figure_title_temp,'_Surface','_Intensity.tif');
                figure_title_png = strcat(figure_title_temp,'_Surface','_Intensity.png');
                figure_title_fig = strcat(figure_title_temp,'_Surface','_Intensity.fig');
                colorbarlabelstr = 'Intensity (W/cm²)';
            elseif strcmp(plottype,'P');
                if maxvaluedisp;
                    maxval_text = ['Maximum P (MPa) = ',sprintf('%0.2f', maxpressure)];
                    text(maxval_Xcoord,maxval_Ycoord,maxval_text,'Color',...
                        maxval_text_color,'FontSize',22);
                end
                maxcb = maxpressure;
                figure_title_tiff = strcat(figure_title_temp,'_Surface','_Pressure.tif');
                figure_title_png = strcat(figure_title_temp,'_Surface','_Pressure.png');
                figure_title_fig = strcat(figure_title_temp,'_Surface','_Pressure.fig');
                colorbarlabelstr = 'Pressure (MPa)';
            elseif strcmp(plottype,'N');
                maxval_text = ['Maximum I (W/cm²) = ',sprintf('%0.2f', maxintensity)];
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
            
            %colorbar setup
            contourvaliter = app.NumContoursField.Value;
            while contourvaliter > 12;
                contourvaliter = floor(contourvaliter/2);
            end    
            cbstep = maxcb/contourvaliter;
            cb = colorbar('LineWidth',1);
            set(cb, 'ylim', [0 maxcb]);
            set(cb,'ytick',[0:cbstep:maxcb]);
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
            
            figure;
            pause(0.00001);
            frame_h = get(handle(gcf),'JavaFrame');
            set(frame_h,'Maximized',1);
            contourf(axis2,axis1,values_to_plot,contours,'LineWidth',.5,'LineColor',app.contourcolordrop.Value);
            
            colorstr = app.colormapdrop.Value;
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
                maxcb = maxintensity;
                figure_title_tiff = strcat(figure_title_temp,'_Intensity.tif');
                figure_title_png = strcat(figure_title_temp,'_Intensity.png');
                figure_title_fig = strcat(figure_title_temp,'_Intensity.fig');
                colorbarlabelstr = 'Intensity (W/cm²)';
            elseif strcmp(plottype,'P');
                if maxvaluedisp;
                    maxval_text = ['Maximum P (MPa) = ',sprintf('%0.2f', maxpressure)];
                    text(maxval_Xcoord,maxval_Ycoord,maxval_text,'Color',...
                        maxval_text_color,'FontSize',22);
                end
                maxcb = maxpressure;
                figure_title_tiff = strcat(figure_title_temp,'_Pressure.tif');
                figure_title_png = strcat(figure_title_temp,'_Pressure.png');
                figure_title_fig = strcat(figure_title_temp,'_Pressure.fig');
                colorbarlabelstr = 'Pressure (MPa)';
            elseif strcmp(plottype,'N');
                maxval_text = ['Maximum I (W/cm²) = ',sprintf('%0.2f', maxintensity)];
                text(maxval_Xcoord,maxval_Ycoord,maxval_text,'Color',...
                    maxval_text_color,'FontSize',22);
                maxcb = 1;
                figure_title_tiff = strcat(figure_title_temp,'_Normalized.tif');
                figure_title_png = strcat(figure_title_temp,'_Normalized.png');
                figure_title_fig = strcat(figure_title_temp,'_Normalized.fig');
                colorbarlabelstr = 'Normalized';
            end
            
            %colorbar setup
            contourvaliter = app.NumContoursField.Value;
            while contourvaliter > 12;
                contourvaliter = floor(contourvaliter/2);
            end    
            cbstep = maxcb/contourvaliter;    
            cb = colorbar('LineWidth',1);
            set(cb, 'ylim', [0 maxcb]);
            set(cb,'ytick',[0:cbstep:maxcb]);
            newticks=cellfun(@(x)sprintf('%.2f',x),num2cell(get(cb,'ytick')),'Un',0);
            set(cb,'yticklabel',newticks);
            cb.Label.String = colorbarlabelstr;
            
            %getcurrentaxes setup XXXX
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
            set(gca,'FontName','Helvetica','FontSize', 20,'LineWidth',2);

            title(graphtitle,'Interpreter', 'none');
            xlabel('mm') % x-axis label
            ylabel('mm') % y-axis label
            
            numofxlines = length(xlines);
            i=1;
            while i<=numofxlines,
                line([xlines(i) xlines(i)],[axis1(1) axis1(end)],'Color',linescolor,...
                    'LineWidth',1.5,'LineStyle','--');
                i = i+1;
            end
            
            numofylines = length(ylines);
            j=1;
            while j<=numofylines,
                line([axis2(1) axis2(end)],[ylines(j) ylines(j)],'Color',linescolor,...
                    'LineWidth',1.5,'LineStyle','--');
                j = j+1;
            end
            
            set(gcf,'PaperPositionMode','auto')
            if saveTIFF;
                saveas(gca,fullfile(BP_file_path,figure_title_tiff),'tiff');
            end
            if savePNG;
                saveas(gca,fullfile(BP_file_path,figure_title_png),'png');
            end
            if saveFIG;
                saveas(gca,fullfile(BP_file_path,figure_title_fig),'fig');
            end
            pause(0.4);
            
         
            
        end
    end
    

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
                        
            % XLINES AND YLINES arrays
            if app.XlinesCheckBox.Value;
                xlines = str2num(app.Xlinesvar2.Value);
            else
                xlines = [];
            end
            if app.YlinesCheckBox2.Value;
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
            if app.HPmodel0500.Value;
                hpvals = dlmread('SenslookupHNR0500.txt','',1,0);
                hydrophone_model = 'HNR-0500';
            elseif app.HPmodel0400old.Value;
                hpvals = dlmread('SenslookupHNP0400.txt','',1,0);
                hydrophone_model = 'HNP-0400 (old)';
            elseif app.HPmodel0400new.Value;
                hpvals = dlmread('SenslookupHNP0400-1430.txt','',1,0);
                hydrophone_model = 'HNP-0400 (new)';
            elseif app.HPmodel0200.Value;
                hpvals = dlmread('SenslookupHNP0200.txt','',1,0);
                hydrophone_model = 'HNP-0200';
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
            if app.gainvallow.Value;
                gaintext = ['Low'];
                capamp = interp1(pavals(:,1),pavals(:,7),freq_in_mhz_p,'linear');
                gaindB = interp1(pavals(:,1),pavals(:,5),freq_in_mhz_p,'linear');
                gain=10.^(gaindB./20); %converting dB to amplitude
                ml=mc.*gain.*caphydro./(caphydro+capamp);
                kcalfactor=zacoustic.*(ml).^2;
            elseif app.gainvalhigh.Value;
                gaintext = ['High'];
                capamp = interp1(pavals(:,1),pavals(:,4),freq_in_mhz_p,'linear');
                gaindB = interp1(pavals(:,1),pavals(:,2),freq_in_mhz_p,'linear');
                gain=10.^(gaindB./20); %converting dB to amplitude
                ml=mc.*gain.*caphydro./(caphydro+capamp);
                kcalfactor=zacoustic.*(ml).^2;
            elseif app.gainvalnone.Value;
                gaintext = ['No'];
                capamp = interp1(pavals(:,1),pavals(:,4),freq_in_mhz_p,'linear');
                gaindB = interp1(pavals(:,1),pavals(:,2),freq_in_mhz_p,'linear');
                kcalfactor = zacoustic.*(mc).^2;
                ml = mc;
            end
            
            intensities = vpp2s./(8*kcalfactor);            %convert each Vpp² to I
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
            
            if app.ColorCheckBox.Value;
                if app.IntensitiesCheckBox.Value;
                    makebeamplot(app,'I','color',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,intensities,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.PressuresCheckBox.Value;
                    makebeamplot(app,'P','color',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,pressures,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.NormplotCheckBox.Value;
                    makebeamplot(app,'N','color',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,normalized,app.NumContoursField.Value,1,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.SurfCheckBox.Value;
                    makesurfplot(app,'I','color',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,intensities,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                    
            end
            if app.BWCheckBox.Value;
                if app.IntensitiesCheckBox.Value;
                    makebeamplot(app,'I','BW',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,intensities,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.PressuresCheckBox.Value;
                    makebeamplot(app,'P','BW',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,pressures,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.NormplotCheckBox.Value;
                    makebeamplot(app,'N','BW',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,normalized,app.NumContoursField.Value,1,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.SurfCheckBox.Value;
                    makesurfplot(app,'I','color',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,app.FIGcheckbox.Value,axis1,axis2,intensities,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
            end

        end

        % Button pushed function: OpenBPButton
        function OpenBPButtonButtonPushed(app, event)
            persistent parentfolder;
            if isempty(parentfolder);
                [filename, pathname] = uigetfile('*.*', 'Select Plot File', 'MultiSelect', 'off');
                app.UIFigure.Visible = 'off';
                app.UIFigure.Visible = 'on';
                if pathname == 0;
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
                if pathname == 0;
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
            if strcmp(fileext,'.xlsx');
                reldata2 = xlsread(fullfile(pathname,filename)); 
                reldata = transpose(reldata2(3:end,1:end)); %reads voltage data from file (and axis1/axis2 coords)
                reldata(1) = 0;
                Ashft = reldata(1,:)';
                Bshft = circshift(Ashft,length(Ashft)-1)';
                reldata(:,1) = Bshft;
                app.Filepathfield.Value = fullfile(pathname, filename);
                app.instructionText.Value = 'No scan parameters loaded from file, please input manually.';
                app.HPmodel0400new.Value = 1;
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
                    app.HPmodel0400new.Value = 1;
                    app.gainvalhigh.Value = 1;
                    set(app.gainvalnone,'enable','off');
                    app.Xoffsetvar.Value = 0;
                    app.Yoffsetvar.Value = 0;
                    app.freq_in_mhz_input.Value = 1;
                    app.GraphTitleField.Value = filename;
                else
                    app.instructionText.Value = 'Scan parameters loaded from file, please verify accuracy.';
                    if strcmp(IDarraytrunc(4),'HNR-0500');
                        app.HPmodel0500.Value = 1;
                        set(app.gainvalnone,'enable','on');
                    elseif strcmp(IDarraytrunc(4),'HNP-0400') || strcmp(IDarraytrunc(4),'HNP-0400 (old)');
                    %elseif strcmp(IDarraytrunc(4),'HNP-0400 (old)');
                        app.HPmodel0400old.Value = 1;
                        app.gainvalhigh.Value = 1;
                        set(app.gainvalnone,'enable','off')
                    elseif strcmp(IDarraytrunc(4),'HNP-0400 (new)');
                        app.HPmodel0400new.Value = 1;
                        app.gainvalhigh.Value = 1;
                        set(app.gainvalnone,'enable','off')
                    elseif strcmp(IDarraytrunc(4),'HNP-0200');
                        app.HPmodel0200.Value = 1;
                        app.gainvalhigh.Value = 1;
                        set(app.gainvalnone,'enable','off')
                    end
                    
                    if strcmp(IDarraytrunc(6),'High');
                        app.gainvalhigh.Value = 1;
                    elseif strcmp(IDarraytrunc(6),'Low');
                        app.gainvallow.Value = 1;
                    elseif strcmp(IDarraytrunc(6),'None');
                        app.gainvalnone.Value = 1;
                    end
                    
                    app.Xoffsetvar.Value = cellfun(@str2num, IDarraytrunc(18));
                    app.Yoffsetvar.Value = cellfun(@str2num, IDarraytrunc(16));
                    app.freq_in_mhz_input.Value = cellfun(@str2num, IDarraytrunc(10));
                    transducerID = char(IDarraytrunc(2));
                    graphtitlestr = [transducerID,'—',filename];
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
            if app.XlinesCheckBox.Value;
                set(app.Xlinesvar2,'enable','on');
            else
                set(app.Xlinesvar2,'enable','off');
            end
        end

        % Value changed function: YlinesCheckBox2
        function YlinesCheckBox2ValueChanged(app, event)
            value = app.YlinesCheckBox2.Value;
            if app.YlinesCheckBox2.Value;
                set(app.Ylinesvar2,'enable','on');
            else
                set(app.Ylinesvar2,'enable','off');
            end            
        end

        % Selection changed function: HPmodel
        function HPmodelSelectionChanged(app, event)
            selectedButton = app.HPmodel.SelectedObject;
            if app.HPmodel0200.Value;
                app.gainvalhigh.Value = 1;
                set(app.gainvalnone,'enable','off');
            elseif app.HPmodel0400old.Value;
                app.gainvalhigh.Value = 1;
                set(app.gainvalnone,'enable','off');
            elseif app.HPmodel0400new.Value;
                app.gainvalhigh.Value = 1;
                set(app.gainvalnone,'enable','off');
            elseif app.HPmodel0500.Value;
                set(app.gainvalnone,'enable','on');
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

        % Callback function
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
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [101 101 556 657];
            app.UIFigure.Name = 'Beam Plot Generator v1.3';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 556 657];

            % Create Tab
            app.Tab = uitab(app.TabGroup);
            app.Tab.Title = 'Generate Beam Plot';

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
            app.instructionText.Position = [40 591 479 25];
            app.instructionText.Value = {'     Select beam plot file.   '};

            % Create Filepathfield
            app.Filepathfield = uieditfield(app.Tab, 'text');
            app.Filepathfield.Editable = 'off';
            app.Filepathfield.Position = [110 554 429 22];

            % Create HPmodel
            app.HPmodel = uibuttongroup(app.Tab);
            app.HPmodel.SelectionChangedFcn = createCallbackFcn(app, @HPmodelSelectionChanged, true);
            app.HPmodel.Title = 'Hydrophone model';
            app.HPmodel.Position = [240 389 129 127];

            % Create HPmodel0200
            app.HPmodel0200 = uiradiobutton(app.HPmodel);
            app.HPmodel0200.Text = 'HNP-0200';
            app.HPmodel0200.Position = [11 81 77 16];

            % Create HPmodel0400old
            app.HPmodel0400old = uiradiobutton(app.HPmodel);
            app.HPmodel0400old.Text = 'HNP-0400 (old)';
            app.HPmodel0400old.Position = [11 59 105 16];

            % Create HPmodel0500
            app.HPmodel0500 = uiradiobutton(app.HPmodel);
            app.HPmodel0500.Text = 'HNR-0500';
            app.HPmodel0500.Position = [11 14 78 16];
            app.HPmodel0500.Value = true;

            % Create HPmodel0400new
            app.HPmodel0400new = uiradiobutton(app.HPmodel);
            app.HPmodel0400new.Text = 'HNP-0400 (new)';
            app.HPmodel0400new.Position = [11 37 111 16];

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
            app.ColorCheckBox.Position = [110 285 52 16];
            app.ColorCheckBox.Value = true;

            % Create BWCheckBox
            app.BWCheckBox = uicheckbox(app.Tab);
            app.BWCheckBox.Text = 'Black and white';
            app.BWCheckBox.Position = [110 255 105 16];

            % Create colormapdrop
            app.colormapdrop = uidropdown(app.Tab);
            app.colormapdrop.Items = {'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', 'copper', 'pink', 'lines', 'colorcube', 'prism', 'flag', 'white'};
            app.colormapdrop.FontSize = 10;
            app.colormapdrop.BackgroundColor = [1 1 1];
            app.colormapdrop.Position = [168 283 48 20];
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

            % Create Label5
            app.Label5 = uilabel(app.Tab);
            app.Label5.HorizontalAlignment = 'right';
            app.Label5.VerticalAlignment = 'top';
            app.Label5.Position = [110 318 53 15];
            app.Label5.Text = 'Contours:';

            % Create NumContoursField
            app.NumContoursField = uieditfield(app.Tab, 'numeric');
            app.NumContoursField.Limits = [0 500];
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

            % Create Tab2
            app.Tab2 = uitab(app.TabGroup);
            app.Tab2.Title = 'Advanced Settings';

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
            app.Label8.Position = [62 515 162 15];
            app.Label8.Text = 'Draw lines at Y-axis Values:';

            % Create Ylinesvar2
            app.Ylinesvar2 = uieditfield(app.Tab2, 'text');
            app.Ylinesvar2.Enable = 'off';
            app.Ylinesvar2.Position = [231 511 61 22];

            % Create LabelDropDown
            app.LabelDropDown = uilabel(app.Tab2);
            app.LabelDropDown.HorizontalAlignment = 'right';
            app.LabelDropDown.VerticalAlignment = 'top';
            app.LabelDropDown.Position = [39 452 114 15];
            app.LabelDropDown.Text = 'Contour line color:';

            % Create contourcolordrop
            app.contourcolordrop = uidropdown(app.Tab2);
            app.contourcolordrop.Items = {'Black', 'White', 'None'};
            app.contourcolordrop.FontSize = 10;
            app.contourcolordrop.BackgroundColor = [1 1 1];
            app.contourcolordrop.Position = [160 449 48 20];
            app.contourcolordrop.Value = 'Black';

            % Create MaxValuesCheckBox
            app.MaxValuesCheckBox = uicheckbox(app.Tab2);
            app.MaxValuesCheckBox.ValueChangedFcn = createCallbackFcn(app, @MaxValuesCheckBoxValueChanged, true);
            app.MaxValuesCheckBox.Text = 'Print Maximum Values on Plot';
            app.MaxValuesCheckBox.Position = [53 483 188.734375 16];

            % Create LabelEditField2
            app.LabelEditField2 = uilabel(app.Tab2);
            app.LabelEditField2.HorizontalAlignment = 'right';
            app.LabelEditField2.VerticalAlignment = 'top';
            app.LabelEditField2.Position = [62 547 162 15];
            app.LabelEditField2.Text = 'Draw lines at X-axis Values:';

            % Create Xlinesvar2
            app.Xlinesvar2 = uieditfield(app.Tab2, 'text');
            app.Xlinesvar2.Enable = 'off';
            app.Xlinesvar2.Position = [231 543 61 22];

            % Create Tab3
            app.Tab3 = uitab(app.TabGroup);
            app.Tab3.Title = 'Readme';

            % Create TextArea
            app.TextArea = uitextarea(app.Tab3);
            app.TextArea.BackgroundColor = [0.9373 0.9373 0.9373];
            app.TextArea.Position = [1 2 552 596];
            app.TextArea.Value = {'Requires lookup tables for the four hydrophones and the preamp.'; ''; 'Select "Open File" and choose a raw beam plot output file from Labview. If the file contains scan '; 'parameters, they will be loaded automatically and the dialog will confirm.'; ''; '"Offset" will introduce an offset to the axes labeling. For example, if a scan began 10 mm from the '; 'transducer, an X offset of 10 will start the graph X-axis at 10 mm. Negative values accepted.'; ''; '9 contours = 10% contours.'; ''; 'Choosing "X lines" or "Y lines" allows drawing of vertical and horizontal lines. Enter values, comma '; 'separated, and lines will be printed at that value on the chosen axis.'; ''; 'For illustrations of the MATLAB-supported colormaps, see: '; 'https://www.mathworks.com/help/matlab/ref/colormap.html'; ''; 'Images are saved to the same folder where the beam plot spreadsheet file was opened from, and '; 'will overwrite older image files without notice.'};

            % Create TextArea2
            app.TextArea2 = uitextarea(app.Tab3);
            app.TextArea2.FontSize = 14;
            app.TextArea2.FontWeight = 'bold';
            app.TextArea2.BackgroundColor = [0.9373 0.9373 0.9373];
            app.TextArea2.Position = [1 597 552 39];
            app.TextArea2.Value = {'Version 1.3 - 08/15/18'};
        end
    end

    methods (Access = public)

        % Construct app
        function app = beamplot_exported

            % Create and configure components
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