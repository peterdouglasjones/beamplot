classdef beamplot < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure                   % Beam Plo...
        OpenBPButton          matlab.ui.control.Button           % Open File
        instructionText       matlab.ui.control.TextArea         %      Sel...
        HPmodel               matlab.ui.container.ButtonGroup    % Hydropho...
        HPmodel0200           matlab.ui.control.RadioButton      % HNP-0200
        HPmodel0400           matlab.ui.control.RadioButton      % HNP-0400
        HPmodel0500           matlab.ui.control.RadioButton      % HNR-0500
        DCBgain               matlab.ui.container.ButtonGroup    % DC Block...
        gainvalhigh           matlab.ui.control.RadioButton      % High
        gainvallow            matlab.ui.control.RadioButton      % Low
        gainvalnone           matlab.ui.control.RadioButton      % None
        XlinesCheckBox        matlab.ui.control.CheckBox        
        YlinesCheckBox2       matlab.ui.control.CheckBox        
        LabelNumericEditField matlab.ui.control.Label            % Frequenc...
        freq_in_mhz_input     matlab.ui.control.NumericEditField % [0 50]
        Label                 matlab.ui.control.Label            % X-axis o...
        Xoffsetvar            matlab.ui.control.NumericEditField % [-500 500]
        Label2                matlab.ui.control.Label            % Y-axis o...
        Yoffsetvar            matlab.ui.control.NumericEditField % [-500 500]
        IntensitiesCheckBox   matlab.ui.control.CheckBox         % Intensit...
        PressuresCheckBox     matlab.ui.control.CheckBox         % Pressure...
        PNGCheckBox           matlab.ui.control.CheckBox         % Save .PNGs
        TIFFCheckBox          matlab.ui.control.CheckBox         % Save .TIFFs
        GeneratePlotButton    matlab.ui.control.Button           % Generate...
        ColorCheckBox         matlab.ui.control.CheckBox         % Color:
        BWCheckBox            matlab.ui.control.CheckBox         % Black an...
        Readme                matlab.ui.control.Button           % Readme
        Label5                matlab.ui.control.Label            % Contours:
        NumContoursField      matlab.ui.control.NumericEditField % [0 500]
        LabelEditField        matlab.ui.control.Label            % Edit Fil...
        GraphTitleField       matlab.ui.control.EditField       
        Filepathfield         matlab.ui.control.EditField       
        Label6                matlab.ui.control.Label            % Scan Par...
        Label7                matlab.ui.control.Label            % Graph Op...
        MaxValuesCheckBox     matlab.ui.control.CheckBox         % Display ...
        NormplotCheckBox      matlab.ui.control.CheckBox         % Normaliz...
        LabelEditField2       matlab.ui.control.Label            % X lines:
        Xlinesvar2            matlab.ui.control.EditField       
        Label8                matlab.ui.control.Label            % Y lines:
        Ylinesvar2            matlab.ui.control.EditField       
        colormapdrop          matlab.ui.control.DropDown         % parula, ...
        LabelDropDown         matlab.ui.control.Label            % Contour ...
        contourcolordrop      matlab.ui.control.DropDown         % Black, W...
        closeallbutton        matlab.ui.control.Button           % Close al...
    end

    
    methods (Access = private)
        
        function dotheplot = makebeamplot(app,plottype,colormapvar,savePNG,saveTIFF,axis1,axis2,values_to_plot,contours,maxvaluedisp,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
            
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
                colorbarlabelstr = 'Pressure (MPa)';
            elseif strcmp(plottype,'N');
                maxval_text = ['Maximum I (W/cm²) = ',sprintf('%0.2f', maxintensity)];
                text(maxval_Xcoord,maxval_Ycoord,maxval_text,'Color',...
                    maxval_text_color,'FontSize',22);
                maxcb = 1;
                figure_title_tiff = strcat(figure_title_temp,'_Normalized.tif');
                figure_title_png = strcat(figure_title_temp,'_Normalized.png');
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
            
            %getcurrentaxes setup
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
            pause(0.4);
        end
    end
    

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
        end

        % GeneratePlotButton button pushed function
        function GeneratePlotButtonButtonPushed(app)
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
            elseif app.HPmodel0400.Value;
                hpvals = dlmread('SenslookupHNP0400.txt','',1,0);
                hydrophone_model = 'HNP-0400';
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
            total_power = avgintensity*axis1_temp(end)*axis2_temp(end)/100;
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
                    makebeamplot(app,'I','color',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,axis1,axis2,intensities,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.PressuresCheckBox.Value;
                    makebeamplot(app,'P','color',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,axis1,axis2,pressures,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.NormplotCheckBox.Value;
                    makebeamplot(app,'N','color',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,axis1,axis2,normalized,app.NumContoursField.Value,1,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
            end
            if app.BWCheckBox.Value;
                if app.IntensitiesCheckBox.Value;
                    makebeamplot(app,'I','BW',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,axis1,axis2,intensities,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.PressuresCheckBox.Value;
                    makebeamplot(app,'P','BW',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,axis1,axis2,pressures,app.NumContoursField.Value,app.MaxValuesCheckBox.Value,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
                if app.NormplotCheckBox.Value;
                    makebeamplot(app,'N','BW',app.PNGCheckBox.Value,app.TIFFCheckBox.Value,axis1,axis2,normalized,app.NumContoursField.Value,1,maxintensity,maxpressure,ylines,xlines,maxval_Xcoord,maxval_Ycoord,graphtitle);
                end
            end

        end

        % OpenBPButton button pushed function
        function OpenBPButtonButtonPushed(app)
            persistent parentfolder;
            if isempty(parentfolder);
                [filename, pathname] = uigetfile('*.*', 'Select Plot File', 'MultiSelect', 'off');
                idcs = strfind(pathname,'\');
                if ispc
                    parentfolder = pathname(1:idcs(end-1));
                    %add a check for ismac when devante is here and I can test on his machine
                    %see if just pathname works
                end
            else
                openparent = strcat(parentfolder,'*.*');
                [filename, pathname] = uigetfile(openparent, 'Select Plot File', 'MultiSelect', 'off');
                idcs = strfind(pathname,'\');
                if ispc
                    parentfolder = pathname(1:idcs(end-1));
                end
            end
            
            [~,~,fileext] = fileparts(filename);
            if strcmp(fileext,'.xlsx');
                reldata2 = xlsread(fullfile(pathname,filename)); 
                app.UIFigure.Visible = 'off';
                app.UIFigure.Visible = 'on';
                reldata = transpose(reldata2(3:end,1:end)); %reads voltage data from file (and axis1/axis2 coords)
                reldata(1) = 0;
                Ashft = reldata(1,:)';
                Bshft = circshift(Ashft,length(Ashft)-1)';
                reldata(:,1) = Bshft;
                app.Filepathfield.Value = fullfile(pathname, filename);
                app.instructionText.Value = 'No scan parameters loaded from file, please input manually.';
                app.HPmodel0400.Value = 1;
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
                app.UIFigure.Visible = 'off';
                app.UIFigure.Visible = 'on';
                app.Filepathfield.Value = fullfile(pathname, filename);
                fid = fopen(fullfile(pathname,filename));
                IDcell = textscan(fid,'%s','Delimiter','\t');
                IDarray = IDcell{1};
                IDarraytrunc = IDarray(1:18);
                fclose(fid);
                
                transducerID = [''];
                if strcmp(IDarraytrunc(3),'')
                    app.instructionText.Value = 'No scan parameters loaded from file, please input manually.';
                    app.HPmodel0400.Value = 1;
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
                    elseif strcmp(IDarraytrunc(4),'HNP-0400');
                        app.HPmodel0400.Value = 1;
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
                    
                    app.Xoffsetvar.Value = cellfun(@str2num, IDarraytrunc(16));
                    app.Yoffsetvar.Value = cellfun(@str2num, IDarraytrunc(18));
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

        % XlinesCheckBox value changed function
        function XlinesCheckBoxValueChanged(app)
            value = app.XlinesCheckBox.Value;
            if app.XlinesCheckBox.Value;
                set(app.Xlinesvar2,'enable','on');
            else
                set(app.Xlinesvar2,'enable','off');
            end
        end

        % YlinesCheckBox2 value changed function
        function YlinesCheckBox2ValueChanged(app)
            value = app.YlinesCheckBox2.Value;
            if app.YlinesCheckBox2.Value;
                set(app.Ylinesvar2,'enable','on');
            else
                set(app.Ylinesvar2,'enable','off');
            end            
        end

        % HPmodel selection change function
        function HPmodelSelectionChanged(app, event)
            selectedButton = app.HPmodel.SelectedObject;
            if app.HPmodel0200.Value;
                app.gainvalhigh.Value = 1;
                set(app.gainvalnone,'enable','off');
            elseif app.HPmodel0400.Value;
                app.gainvalhigh.Value = 1;
                set(app.gainvalnone,'enable','off');
            elseif app.HPmodel0500.Value;
                set(app.gainvalnone,'enable','on');
            end
            
        end

        % ColormapField value changed function
        function ColormapFieldValueChanged(app)
            colormapvalue = app.ColormapField.Value;
            
        end

        % MaxValuesCheckBox value changed function
        function MaxValuesCheckBoxValueChanged(app)
            value = app.MaxValuesCheckBox.Value;
            
        end

        % NormplotCheckBox value changed function
        function NormplotCheckBoxValueChanged(app)
            value = app.NormplotCheckBox.Value;
            
        end

        % Readme button pushed function
        function ReadmeButtonPushed(app)
            h = figure;
            hp = uipanel(h,'Title','Readme','FontSize',12,...
                'Position',[0 0 1 1]);
            btn = uicontrol(h,'Style', 'pushbutton', 'String', 'Close Readme',...
                'Position', [18 18 90 36],...
                'Callback', @closefigh);

            readmetextstr = {'Requires lookup tables for the three hydrophones and the preamp.'...
                ,''...
                'Select "Open File" and choose a raw beam plot output file from Labview. If the file contains scan parameters, they will be loaded automatically and the dialog will confirm.'...
                ,''...
                '"Offset" will introduce an offset to the axes labeling. For example, if a scan began 10 mm from the transducer, an X offset of 10 will start the graph X-axis at 10 mm. Negative values accepted.'...
                ,''...
                'Choosing "X lines" or "Y lines" allows drawing of vertical and horizontal lines. Enter values, comma separated, and lines will be printed at that value on the chosen axis.'...
                ,''...
                'For illustrations of the MATLAB-supported colormaps, see: https://www.mathworks.com/help/matlab/ref/colormap.html'...
                ,''...
                'Images are saved to the same folder as the beam plot spreadsheet file, and will overwrite older image files without notice.'...
                ,''...
                };
                
                readmetext = uicontrol('Style', 'text');
                readmetext.Parent = hp;
                readmetext.Units = 'normalized';
                %align(readmetext,'HorizontalAlignment','Left');
                readmetext.Position = [.03    .03    .94    .92];
                readmetext.FontSize = 10;
                readmetext.String = readmetextstr;

                function closefigh(source,event)
                    close(h);
                end
             
%                 Code for "advanced options" window in the future
%                 advwindow = figure;
%                 advpanel = uipanel
%                     advpanel.Title = 'Advanced';
%                     advpanel.BorderType = 'line';
%                     advpanel.Title = 'Advanced Options';
%                     advpanel.FontName = 'Helvetica';
%                     advpanel.FontUnits = 'pixels';
%                     advpanel.FontSize = 12;
%                     advpanel.Units = 'normalized';
%                     advpanel.Position = [0 0 1 1];
            
        end

        % closeallbutton button pushed function
        function ButtonButtonPushed(app)
% 
        end

        % closeallbutton button pushed function
        function closeallbuttonpush(app)
            close all;
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 543 595];
            app.UIFigure.Name = 'Beam Plot Generator';
            setAutoResize(app, app.UIFigure, true)

            % Create OpenBPButton
            app.OpenBPButton = uibutton(app.UIFigure, 'push');
            app.OpenBPButton.ButtonPushedFcn = createCallbackFcn(app, @OpenBPButtonButtonPushed);
            app.OpenBPButton.Position = [29 494 77 22];
            app.OpenBPButton.Text = 'Open File';

            % Create instructionText
            app.instructionText = uitextarea(app.UIFigure);
            app.instructionText.Editable = 'off';
            app.instructionText.HorizontalAlignment = 'center';
            app.instructionText.FontSize = 14;
            app.instructionText.BackgroundColor = [0.9373 0.9373 0.9373];
            app.instructionText.Position = [29 542 482 25];
            app.instructionText.Value = {'     Select beam plot file.   '};

            % Create HPmodel
            app.HPmodel = uibuttongroup(app.UIFigure);
            app.HPmodel.SelectionChangedFcn = createCallbackFcn(app, @HPmodelSelectionChanged, true);
            app.HPmodel.BorderType = 'line';
            app.HPmodel.Title = 'Hydrophone model';
            app.HPmodel.FontName = 'Helvetica';
            app.HPmodel.FontUnits = 'pixels';
            app.HPmodel.FontSize = 12;
            app.HPmodel.Units = 'pixels';
            app.HPmodel.Position = [231 335 123 106];

            % Create HPmodel0200
            app.HPmodel0200 = uiradiobutton(app.HPmodel);
            app.HPmodel0200.Text = 'HNP-0200';
            app.HPmodel0200.Position = [10 59 77 16];

            % Create HPmodel0400
            app.HPmodel0400 = uiradiobutton(app.HPmodel);
            app.HPmodel0400.Value = true;
            app.HPmodel0400.Text = 'HNP-0400';
            app.HPmodel0400.Position = [10 37 77 16];

            % Create HPmodel0500
            app.HPmodel0500 = uiradiobutton(app.HPmodel);
            app.HPmodel0500.Text = 'HNR-0500';
            app.HPmodel0500.Position = [10 15 78 16];

            % Create DCBgain
            app.DCBgain = uibuttongroup(app.UIFigure);
            app.DCBgain.BorderType = 'line';
            app.DCBgain.Title = 'DC Block Gain';
            app.DCBgain.FontName = 'Helvetica';
            app.DCBgain.FontUnits = 'pixels';
            app.DCBgain.FontSize = 12;
            app.DCBgain.Units = 'pixels';
            app.DCBgain.Position = [371 335 123 106];

            % Create gainvalhigh
            app.gainvalhigh = uiradiobutton(app.DCBgain);
            app.gainvalhigh.Value = true;
            app.gainvalhigh.Text = 'High';
            app.gainvalhigh.Position = [10 59 45 16];

            % Create gainvallow
            app.gainvallow = uiradiobutton(app.DCBgain);
            app.gainvallow.Text = 'Low';
            app.gainvallow.Position = [10 37 42 16];

            % Create gainvalnone
            app.gainvalnone = uiradiobutton(app.DCBgain);
            app.gainvalnone.Enable = 'off';
            app.gainvalnone.Text = 'None';
            app.gainvalnone.Position = [10 15 49 16];

            % Create XlinesCheckBox
            app.XlinesCheckBox = uicheckbox(app.UIFigure);
            app.XlinesCheckBox.ValueChangedFcn = createCallbackFcn(app, @XlinesCheckBoxValueChanged);
            app.XlinesCheckBox.Text = '';
            app.XlinesCheckBox.Position = [70 198 22 16];

            % Create YlinesCheckBox2
            app.YlinesCheckBox2 = uicheckbox(app.UIFigure);
            app.YlinesCheckBox2.ValueChangedFcn = createCallbackFcn(app, @YlinesCheckBox2ValueChanged);
            app.YlinesCheckBox2.Text = '';
            app.YlinesCheckBox2.Position = [70 169 22 16];

            % Create LabelNumericEditField
            app.LabelNumericEditField = uilabel(app.UIFigure);
            app.LabelNumericEditField.HorizontalAlignment = 'right';
            app.LabelNumericEditField.Position = [46 416 94 15];
            app.LabelNumericEditField.Text = 'Frequency (MHz)';

            % Create freq_in_mhz_input
            app.freq_in_mhz_input = uieditfield(app.UIFigure, 'numeric');
            app.freq_in_mhz_input.Limits = [0 50];
            app.freq_in_mhz_input.ValueDisplayFormat = '%.2f';
            app.freq_in_mhz_input.Position = [157 412 46 22];
            app.freq_in_mhz_input.Value = 1;

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Position = [30 382 110 15];
            app.Label.Text = 'X-axis offset (mm)';

            % Create Xoffsetvar
            app.Xoffsetvar = uieditfield(app.UIFigure, 'numeric');
            app.Xoffsetvar.Limits = [-500 500];
            app.Xoffsetvar.Position = [157 378 46 22];

            % Create Label2
            app.Label2 = uilabel(app.UIFigure);
            app.Label2.HorizontalAlignment = 'right';
            app.Label2.Position = [30 347 110 15];
            app.Label2.Text = 'Y-axis offset (mm)';

            % Create Yoffsetvar
            app.Yoffsetvar = uieditfield(app.UIFigure, 'numeric');
            app.Yoffsetvar.Limits = [-500 500];
            app.Yoffsetvar.Position = [157 343 46 22];

            % Create IntensitiesCheckBox
            app.IntensitiesCheckBox = uicheckbox(app.UIFigure);
            app.IntensitiesCheckBox.Text = 'Intensity Plot';
            app.IntensitiesCheckBox.Position = [218 255 88 16];
            app.IntensitiesCheckBox.Value = true;

            % Create PressuresCheckBox
            app.PressuresCheckBox = uicheckbox(app.UIFigure);
            app.PressuresCheckBox.Text = 'Pressure Plot';
            app.PressuresCheckBox.Position = [218 227 92 16];

            % Create PNGCheckBox
            app.PNGCheckBox = uicheckbox(app.UIFigure);
            app.PNGCheckBox.Text = 'Save .PNGs';
            app.PNGCheckBox.Position = [375 198 85 16];
            app.PNGCheckBox.Value = true;

            % Create TIFFCheckBox
            app.TIFFCheckBox = uicheckbox(app.UIFigure);
            app.TIFFCheckBox.Text = 'Save .TIFFs';
            app.TIFFCheckBox.Position = [375 170 83 16];

            % Create GeneratePlotButton
            app.GeneratePlotButton = uibutton(app.UIFigure, 'push');
            app.GeneratePlotButton.ButtonPushedFcn = createCallbackFcn(app, @GeneratePlotButtonButtonPushed);
            app.GeneratePlotButton.BackgroundColor = [0.9373 0.9373 0.9373];
            app.GeneratePlotButton.FontWeight = 'bold';
            app.GeneratePlotButton.Position = [212 40 138 47];
            app.GeneratePlotButton.Text = 'Generate Plot';

            % Create ColorCheckBox
            app.ColorCheckBox = uicheckbox(app.UIFigure);
            app.ColorCheckBox.Text = 'Color:';
            app.ColorCheckBox.Position = [375 255 52 16];
            app.ColorCheckBox.Value = true;

            % Create BWCheckBox
            app.BWCheckBox = uicheckbox(app.UIFigure);
            app.BWCheckBox.Text = 'Black and white';
            app.BWCheckBox.Position = [375 227 105 16];

            % Create Readme
            app.Readme = uibutton(app.UIFigure, 'push');
            app.Readme.ButtonPushedFcn = createCallbackFcn(app, @ReadmeButtonPushed);
            app.Readme.FontSize = 10;
            app.Readme.FontAngle = 'italic';
            app.Readme.Position = [487 0 56 22];
            app.Readme.Text = 'Readme';

            % Create Label5
            app.Label5 = uilabel(app.UIFigure);
            app.Label5.HorizontalAlignment = 'right';
            app.Label5.Position = [76 256 53 15];
            app.Label5.Text = 'Contours:';

            % Create NumContoursField
            app.NumContoursField = uieditfield(app.UIFigure, 'numeric');
            app.NumContoursField.Limits = [0 500];
            app.NumContoursField.Position = [135 252 48 22];
            app.NumContoursField.Value = 10;

            % Create LabelEditField
            app.LabelEditField = uilabel(app.UIFigure);
            app.LabelEditField.HorizontalAlignment = 'right';
            app.LabelEditField.Position = [33 115 152 15];
            app.LabelEditField.Text = 'Edit Filename and Plot Title:';

            % Create GraphTitleField
            app.GraphTitleField = uieditfield(app.UIFigure, 'text');
            app.GraphTitleField.Position = [192 111 319 22];

            % Create Filepathfield
            app.Filepathfield = uieditfield(app.UIFigure, 'text');
            app.Filepathfield.Editable = 'off';
            app.Filepathfield.Position = [113 494 398 22];

            % Create Label6
            app.Label6 = uilabel(app.UIFigure);
            app.Label6.FontSize = 14;
            app.Label6.FontWeight = 'bold';
            app.Label6.Position = [54 450 119 18];
            app.Label6.Text = 'Scan Parameters:';

            % Create Label7
            app.Label7 = uilabel(app.UIFigure);
            app.Label7.FontSize = 14;
            app.Label7.FontWeight = 'bold';
            app.Label7.Position = [55 287 106 18];
            app.Label7.Text = 'Graph Options:';

            % Create MaxValuesCheckBox
            app.MaxValuesCheckBox = uicheckbox(app.UIFigure);
            app.MaxValuesCheckBox.ValueChangedFcn = createCallbackFcn(app, @MaxValuesCheckBoxValueChanged);
            app.MaxValuesCheckBox.Text = 'Display Max Values';
            app.MaxValuesCheckBox.Position = [218 170 127 16];

            % Create NormplotCheckBox
            app.NormplotCheckBox = uicheckbox(app.UIFigure);
            app.NormplotCheckBox.ValueChangedFcn = createCallbackFcn(app, @NormplotCheckBoxValueChanged);
            app.NormplotCheckBox.Text = 'Normalized Plot';
            app.NormplotCheckBox.Position = [218 198 106 16];

            % Create LabelEditField2
            app.LabelEditField2 = uilabel(app.UIFigure);
            app.LabelEditField2.HorizontalAlignment = 'right';
            app.LabelEditField2.Position = [89 200 40 15];
            app.LabelEditField2.Text = 'X lines:';

            % Create Xlinesvar2
            app.Xlinesvar2 = uieditfield(app.UIFigure, 'text');
            app.Xlinesvar2.Enable = 'off';
            app.Xlinesvar2.Position = [135 196 48 22];

            % Create Label8
            app.Label8 = uilabel(app.UIFigure);
            app.Label8.HorizontalAlignment = 'right';
            app.Label8.Position = [89 171 40 15];
            app.Label8.Text = 'Y lines:';

            % Create Ylinesvar2
            app.Ylinesvar2 = uieditfield(app.UIFigure, 'text');
            app.Ylinesvar2.Enable = 'off';
            app.Ylinesvar2.Position = [135 167 48 22];

            % Create colormapdrop
            app.colormapdrop = uidropdown(app.UIFigure);
            app.colormapdrop.Items = {'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', 'copper', 'pink', 'lines', 'colorcube', 'prism', 'flag', 'white'};
            app.colormapdrop.FontSize = 10;
            app.colormapdrop.BackgroundColor = [1 1 1];
            app.colormapdrop.Position = [432 253 48 20];
            app.colormapdrop.Value = 'parula';

            % Create LabelDropDown
            app.LabelDropDown = uilabel(app.UIFigure);
            app.LabelDropDown.HorizontalAlignment = 'right';
            app.LabelDropDown.Position = [51 228 77 15];
            app.LabelDropDown.Text = 'Contour color:';

            % Create contourcolordrop
            app.contourcolordrop = uidropdown(app.UIFigure);
            app.contourcolordrop.Items = {'Black', 'White', 'None'};
            app.contourcolordrop.FontSize = 10;
            app.contourcolordrop.BackgroundColor = [1 1 1];
            app.contourcolordrop.Position = [135 225 48 20];
            app.contourcolordrop.Value = 'Black';

            % Create closeallbutton
            app.closeallbutton = uibutton(app.UIFigure, 'push');
            app.closeallbutton.ButtonPushedFcn = createCallbackFcn(app, @closeallbuttonpush);
            app.closeallbutton.FontSize = 11;
            app.closeallbutton.FontAngle = 'italic';
            app.closeallbutton.Position = [0 0 87 22];
            app.closeallbutton.Text = 'Close all figures';
        end
    end

    methods (Access = public)

        % Construct app
        function app = beamplot()

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

