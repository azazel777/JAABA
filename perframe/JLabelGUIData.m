classdef JLabelGUIData < handle
  % This class holds a lot of information about the JLabel GUI, so that it
  % doesn't have to be copied as much.
  %
  % In the future, it might make sense to refactor things so that JLabel 
  % functions dealing entirely with visual aspects into here.  Also, some 
  % functions of JLabel might be refactored such that the visual aspects are 
  % done in methods of this class.  All of this would make this class
  % closer to a View in the Model-View-Controller sense.  --ALT, May 1 2013
  
  properties (Constant)
    LABELSTATE = struct(... % see label_state
      'UnknownAll',-100,...
      'NoneAll',100);
    
    COLOR_BEH_DEFAULT = [0.7 0 0];
    COLOR_NOBEH_DEFAULT = [0 0 0.7];

    % JLabel handles stored in this obj for convenience
    JLABEL_GUIDATA_HANDLES = { ...
      'axes_timeline_auto';
      'menu_view_manual_labels';
      'menu_view_automatic_labels';
      'timeline_label_manual';
      'timeline_label_automatic';
      'automaticTimelinePopup';
    };
  end

  properties (Access=public)
    status_bar_text_when_clear = '';
    idlestatuscolor = [0,1,0];
    busystatuscolor = [1,0,1];

    movie_depth = 1;
%     movie_height = 100;
%     movie_width = 100;
    movie_minx = 1;
    movie_miny = 1;
    movie_maxx = 100;
    movie_maxy = 100;
    movie_pixelsize = 1;
    movie_filename = [];

    panel_previews = [];
    axes_previews = [];
    slider_previews = [];
    edit_framenumbers = [];
    pushbutton_playstops = [];
    
    hsplash = [];
    hsplashstatus = [];
   
    guipos = struct;

    rcfilename = '';
    rc = struct;

    timeline_nframes = 250;
    nframes_jump_go = 30;

    label_shortcuts = [];

    outavi_compression = 'None';
    outavi_fps = 15;
    outavi_quality = 95;
    useVideoWriter = false;

    play_FPS = 2;
    framecache_threads = 1;
    computation_threads = 1;
    traj_nprev = 25;
    traj_npost = 25;
    
    % JLabel figure handle
    hJLabel;
    
    % JLabelData handle
    data = [];
    
    % Subset of JLabel handles, ie subset of guidata(hJLabel)
    gdata = struct(); 

    nflies_label = 1;

    ts = 0;
    
    % label_state
    % - If zero, no labeling is in progress
    % - If positive, labeling of <behavior idx>=label_state is in progress
    % - If negative, unknown-labeling of <behavior idx>=|label_state| is in progress
    % - If equal to LABELSTATE.UnknownAll, unknown-labeling of all behaviors is in progress
    % - If equal to LABELSTATE.NoneAll, none-labeling of all behaviors is in progress
    label_state = 0;
    
    label_imp = [];
    
    oldexpdir='';  % Used by JLabel's File > Edit files...

    in_border_y = [];
    labelcolors = [];
    labelunknowncolor = [0,0,0];
    labelnoneallcolor = [0.5,0.5,0.5];
    % nextra_markers = 1;
    % flies_extra_markersize = 12;
    % flies_extra_marker = {'o'};
    % flies_extra_linestyle = {'-'};

    % nclassifiers-by-1 cell array. Each element sc = scorecolor{iCls} is
    % 63x3x3.
    % sc(:,:,1) are regular colors. 
    % sc(:,:,2) and sc(:,:,3) are shifted forwards/backwards resp.
    % AL 20150218 appears only values in sc(:,:,1) are used.
    scorecolor = []; 
    
    correctcolor = [0,.7,0];
    incorrectcolor = [.7,.7,0];
    suggestcolor = [0,.7,.7];
    selection_color = [1,.6,0];
    selection_alpha = .5;
    emphasiscolor = [.7,.7,0];
    unemphasiscolor = [1,1,1];

    % togglebutton handles for labeling behaviors
    togglebutton_label_behaviors = []; 
    % togglebutton handles for behavior-specific unknowns 
    togglebutton_unknown_behaviors = [];
    % convenience property, togglebutton_unknown_behaviors plus "Universal unknown" togglebutton
    togglebutton_unknowns = [];     
    togglebutton_label_noneall = [];
    
%     GUIGroundTruthingMode = [];  % true iff the GUI is in ground truth mode, as
%                                  % opposed to labeling mode.  Empty if
%                                  % no project is currently loaded.
    GUIAdvancedMode = false;  % true iff the GUI is in advanced mode, as
                              % opposed to basic mode

    timeline_prop_remove_string = '<html><body><i>Remove</i></body></html>';
    timeline_prop_help_string = '<html><body><i>Help</i></body></html>';
    timeline_prop_options = {};
    
    d = '';
    perframepropis = 1;

    timeline_data_ylims = [];
    
    max_click_dist_preview = .025^2;
    
    preview_zoom_mode = 'follow_fly';
    zoom_fly_radius = nan(1,2);
    meana = 1;
    
    menu_view_zoom_options = [];

    selection_t0 = nan;
    selection_t1 = nan;
    selected_ts = nan(1,2);
    buttondown_t0 = nan;
    buttondown_axes = nan;
    selecting = false;
    
    NJObj = [];
    shouldOpenMovieIfPresent=true;  % if false, we don't show the movie, even if it's available
    thisMoviePresent=false;  % set to true once we know the current movie exists.
    
    hplaying = nan;

    bookmark_windows = [];
    

    doFastUpdates = true;

    axes_preview_curr = 1;
    hslider_listeners = [];    
    
    htrx = [];
    fly_colors = [];
    himage_previews = [];
    
    %% Timelines
    
    % mirrors automatictimelineBottomRowPopup
    bottomAutomatic = 'None';
    
    axes_timelines = [];
    
    % handle vector. auto timeline controls visible when behaviorFocus is on
    auto_timeline_controls_behaviorFocusOn = [];
    % handle vector. auto timeline controls visible when behaviorFocus is off
    auto_timeline_controls_behaviorFocusOff = [];
    
    labels_timelines = [];
    axes_timeline_props = [];
    axes_timeline_labels = [];
    text_timeline_props = [];
    text_timelines = [];    

    %% Trx Position/Overlay 
    plot_labels_manual = true;
    plot_labels_automatic = false;

    hflies = [];       % nfly-by-numAxes handle array. The triangle marking each fly.
    hflies_extra = [];
    hfly_markers = []; % nfly-by-numAxes handle array. The dot/star at the center of each fly.
    
    hlabel_curr = [];  % 1-by-numAxes handle. The line showing labeling-in-progress.
    hlabels = [];      % 1-by-nbehavior handle array. The lines (trx-overlay) showing labels for each behavior.
    hpredicted = [];   % 1-by-nbehavior handle array. The lines (trx-overlay) showing predictions for each behavior.
    
    %%
    
    hlabelstarts = [];
    hzoom = [];
    hpan = [];
    himage_timeline_manual = [];
    htimeline_label_curr = [];
    himage_timeline_auto = [];
    htimeline_data = [];
    htimeline_errors = [];
    htimeline_suggestions = [];
    htimeline_gt_suggestions = [];
    hcurr_timelines = [];
    hselection = [];
    bkgdgrid = zeros(2,0);
    hrois = [];
    harena = [];
    
    callbacks = struct;

    readframe = [];
    nframes = nan;
    movie_fid = [];
    movieheaderinfo = struct;
    % t0_curr = nan;
    % t1_curr = nan;
    labels_plot = struct; % See LabelsPlot
    % labels_plot_off = nan;

    current_interval = [];
    didclearselection = false;
    
    open_peripherals = [];

    cache_thread = [];
    cache_size = 200;
    cache_filename = [];
    % cacheSize = 4000;  % now stored only in JLabelData
     
    tempname = [];
    
    % which flies are being plotted
    fly2idx = [];
    idx2fly = [];
    
    showPredictionsAllFlies = false;
    
    defaultmoviefilename = 0;
    defaulttrxfilename = 0;
    
    GTSuggestions = struct;
    
    maxWindowRadiusCommonCached = [];  
      % need to remember between calls to SelectFeatures, because it needs
      % to override the max_window_radius in the window-feature amount
      % presets in the feature lexicon, and these WF amount presets are not
      % retained in the feature vocabulary.  (And we don't want to retain
      % them in JLabelData's feature vocabulary, b/c they're not _really_
      % part of the feature vocabulary.)  (But I suppose we could add them
      % if we wanted to...)   
  end
  
  properties (SetAccess=private)
    % scalar logical. If true, UI focuses on a single classifier. This is
    % the default for single-classifier projects, but toggleable for
    % multi-classifier projects.
    behaviorFocusOn = false;
    
    % scalar integer. If behaviorFocusOn==true, behaviorFocusIdx is the
    % classifier index currently in focus.
    behaviorFocusIdx;
    
    % 1x2 row vec, behavior/label indices corresponding to behaviorFocusIdx.
    behaviorFocusLbls;
  end
    
  methods (Access=public)
    
    function obj = JLabelGUIData(jld,jlabel)
      % Constructor
      % jld: JLabelData object
      % jlabel: JLabel figure handle
      
      obj.data = jld;  % store a reference to the "model"
      
      obj.hJLabel = jlabel;
      handles = guidata(jlabel);
      flds2Rm = setdiff(fieldnames(handles),obj.JLABEL_GUIDATA_HANDLES);
      obj.gdata = rmfield(handles,flds2Rm);
      
      if verLessThan('matlab','8.3.0.532'),
        obj.computation_threads = max(1,matlabpool('size'));        
      else
        if isempty(gcp('nocreate')),
          obj.computation_threads = 0;
        else
          c = gcp;
          obj.computation_threads = c.NumWorkers;        
        end
      end
    end
   
    % ---------------------------------------------------------------------
    function UpdateGraphicsHandleArrays(self, figure_JLabel)
      % Update the arrays of grandles within ourself to match the widgets
      % in the JLabel figure.
      % all axes panels
      self.panel_previews = findobj(figure_JLabel,'-regexp','Tag','panel_axes\d+');
      % all preview axes
      self.axes_previews = findobj(figure_JLabel,'Tag','axes_preview');
      % all sliders
      self.slider_previews = findobj(figure_JLabel,'Tag','slider_preview');
      % all frame number edit boxes
      self.edit_framenumbers = findobj(figure_JLabel,'Tag','edit_framenumber');
      % all play buttons
      self.pushbutton_playstops = findobj(figure_JLabel,'Tag','pushbutton_playstop');
      % all timelines
      self.axes_timelines = findobj(figure_JLabel,'-regexp','Tag','^axes_timeline.*')';
      % self.labels_timelines = findobj(handles.figure_JLabel,'-regexp','Tag','^timeline_label.*');
      % Regex messes the order which makes it difficult to remove the last data axes.
      handles = guidata(figure_JLabel);
            
      self.auto_timeline_controls_behaviorFocusOn = [...
        handles.automaticTimelinePredictionLabel; ...
        handles.automaticTimelineScoresLabel; ...
        handles.automaticTimelineBottomRowPopup; ...
        handles.text_scores];      
      self.auto_timeline_controls_behaviorFocusOff = [...
        handles.automaticTimelinePopup];
        
      self.labels_timelines(1,1) = handles.timeline_label_prop1;
      self.labels_timelines(2,1) = handles.timeline_label_automatic;
      self.labels_timelines(3,1) = handles.timeline_label_manual;

      self.axes_timeline_props = findobj(figure_JLabel,'-regexp','Tag','^axes_timeline_prop.*')';
      self.axes_timeline_labels = setdiff(self.axes_timelines,self.axes_timeline_props);

      if numel(self.labels_timelines) ~= numel(self.labels_timelines), % AL ????
        error('Number of timeline axes does not match number of timeline labels');
      end
      % sort by y-position
      ys = nan(1,numel(self.axes_timelines));
      for i = 1:numel(self.axes_timelines),
        pos = get(self.axes_timelines(i),'Position');
        ys(i) = pos(2);
      end
      [~,order] = sort(ys);
      self.axes_timelines = self.axes_timelines(order);
      % sort by y-position. 
      % Don't touch the last 2 labels that are part of manual and automatic timeline
      % because they are inside a panel and so pos(2) is relative to the panel.
      ys = nan(1,numel(self.labels_timelines)-2);
      for i = 1:(numel(self.labels_timelines)-2),
        pos = get(self.labels_timelines(i),'Position');
        ys(i) = pos(2);
      end
      [~,order] = sort(ys);
      temp = self.labels_timelines(1:end-2);
      self.labels_timelines(1:end-2) = temp(order);

      self.text_timeline_props = nan(size(self.axes_timeline_props));
      self.text_timelines = nan(size(self.axes_timelines));
      [~,idx] = ismember(self.axes_timeline_props,self.axes_timelines);
      for ii = 1:numel(self.axes_timeline_props),
        i = idx(ii);
        t = get(self.axes_timeline_props(ii),'Tag');
        m = regexp(t,'^axes_timeline_prop(.*)$','tokens','once');
        t2 = ['text_timeline_prop',m{1}];
        self.text_timeline_props(ii) = handles.(t2);
        self.text_timelines(i) = self.text_timeline_props(ii);
      end
    end
    
    % ---------------------------------------------------------------------
    function setLayout(self,figureJLabel)
      % Calculates various aspects of the layout, sets a bunch of stuff in
      % self appropriately.      
      handles=guidata(figureJLabel);  
        % note that we only read from handles, and we never write it back
        % to the figure
      figpos = get(figureJLabel,'Position');
      panel_labelbuttons_pos = get(handles.panel_labelbuttons,'Position');
      % panel_learn_pos = get(handles.panel_learn,'Position');
      panel_timelines_pos = get(handles.panel_timelines,'Position');
      panel_previews_pos = cell(size(self.panel_previews));
      for i = 1:numel(self.panel_previews),
        panel_previews_pos{i} = get(self.panel_previews(i),'Position');
      end
      self.guipos.width_rightpanels = panel_labelbuttons_pos(3);
      self.guipos.rightborder_rightpanels = figpos(3) - (panel_labelbuttons_pos(1) + panel_labelbuttons_pos(3));
      self.guipos.leftborder_leftpanels = panel_timelines_pos(1);
      self.guipos.leftborder_rightpanels = panel_labelbuttons_pos(1) - (panel_timelines_pos(1) + panel_timelines_pos(3));
      self.guipos.topborder_toppanels = figpos(4) - (panel_labelbuttons_pos(2) + panel_labelbuttons_pos(4));
      if self.guipos.topborder_toppanels < 0
        self.guipos.topborder_toppanels = 15;
      end
      self.guipos.bottomborder_bottompanels = panel_timelines_pos(2);
      self.guipos.bottomborder_previewpanels = panel_previews_pos{end}(2) - (panel_timelines_pos(2)+panel_timelines_pos(4));
      self.guipos.frac_height_timelines = panel_timelines_pos(4) / (panel_timelines_pos(4) + panel_previews_pos{1}(4));

      self.guipos.timeline_bottom_borders = nan(1,numel(self.axes_timelines));
      self.guipos.timeline_left_borders = nan(1,numel(self.axes_timelines));
      self.guipos.timeline_label_middle_offsets = nan(1,numel(self.axes_timelines));
      pos0 = get(self.axes_timelines(1),'Position');
      self.guipos.timeline_bottom_borders(1) = pos0(2);
      self.guipos.timeline_heights(1) = pos0(4);
      self.guipos.timeline_xpos = pos0(1);
      self.guipos.timeline_rightborder = panel_timelines_pos(3) - pos0(1) - pos0(3);
      for i = 2:numel(self.axes_timelines),
        pos1 = get(self.axes_timelines(i),'Position');
        self.guipos.timeline_bottom_borders(i) = pos1(2) - pos0(2) - pos0(4);
        self.guipos.timeline_heights(i) = pos1(4);
        pos0 = pos1;
      end
      self.guipos.timeline_top_border = panel_timelines_pos(4) - pos1(2) - pos1(4);
      self.guipos.timeline_heights = self.guipos.timeline_heights / sum(self.guipos.timeline_heights);
      for i = 1:numel(self.axes_timelines),
        ax_pos = get(self.axes_timelines(i),'Position');
        label_pos = get(self.labels_timelines(i),'Position');
        self.guipos.timeline_left_borders(i) = label_pos(1);
        m = ax_pos(2) + ax_pos(4)/2;
        self.guipos.timeline_label_middle_offsets(i) = label_pos(2)-m;
      end
      ax_pos = get(handles.axes_timeline_prop1,'Position');
      self.guipos.timeline_prop_height = ax_pos(4);
      pos = get(handles.timeline_label_prop1,'Position');
      self.guipos.timeline_prop_label_left_border = pos(1);
      self.guipos.timeline_prop_label_size = pos(3:4);
      self.guipos.timeline_prop_label_callback = get(handles.timeline_label_prop1,'Callback');
      self.guipos.timeline_prop_fontsize = get(handles.timeline_label_prop1,'FontSize');
      m = ax_pos(2) + ax_pos(4)/2;
      self.guipos.timeline_prop_label_middle_offset = pos(2)-m;

      pos = get(handles.text_timeline_prop1,'Position');
      self.guipos.text_timeline_prop_right_border = ax_pos(1) - pos(1) - pos(3);
      self.guipos.text_timeline_prop_size = pos(3:4);
      self.guipos.text_timeline_prop_middle_offset = pos(2)-m;
      self.guipos.text_timeline_prop_fontsize = get(handles.text_timeline_prop1,'FontSize');
      self.guipos.text_timeline_prop_bgcolor = get(handles.text_timeline_prop1,'BackgroundColor');
      self.guipos.text_timeline_prop_fgcolor = get(handles.text_timeline_prop1,'ForegroundColor');

      axes_pos = get(handles.axes_preview,'Position');
      slider_pos = get(handles.slider_preview,'Position');
      edit_pos = get(handles.edit_framenumber,'Position');
      play_pos = get(handles.pushbutton_playstop,'Position');
      self.guipos.preview_axes_top_border = panel_previews_pos{end}(4) - axes_pos(4) - axes_pos(2);
      self.guipos.preview_axes_bottom_border = axes_pos(2);
      self.guipos.preview_axes_left_border = axes_pos(1);
      self.guipos.preview_axes_right_border = panel_previews_pos{end}(3) - axes_pos(1) - axes_pos(3);
      self.guipos.preview_slider_left_border = slider_pos(1);
      self.guipos.preview_slider_right_border = panel_previews_pos{end}(3) - slider_pos(1) - slider_pos(3);
      self.guipos.preview_slider_bottom_border = slider_pos(2);
      self.guipos.preview_play_left_border = play_pos(1) - slider_pos(1) - slider_pos(3);
      self.guipos.preview_play_bottom_border = play_pos(2);
      self.guipos.preview_edit_left_border = edit_pos(1) - play_pos(1) - play_pos(3);
      self.guipos.preview_edit_bottom_border = edit_pos(2);
    end  % method
    
    % ---------------------------------------------------------------------
    function initializeAfterBasicParamsSet(self)
      % number of flies to label at a time
      self.nflies_label = 1;
      
      % by default, be in advanced mode if ground-truthing and basic mode
      % if training
      self.GUIAdvancedMode = self.data.gtMode;

      self.ts = 0;

      % current behavior labeling state: nothing down
      self.label_state = 0;
      self.label_imp = [];

      % ALTODO call to this method seems unnecessary, just init directly off
      % self.data
      basicParamsStruct = self.data.getBasicParamsStruct();
      % label colors
      if isfield(basicParamsStruct,'behaviors') && ...
         isfield(basicParamsStruct.behaviors,'labelcolors'),
        labelcolors = basicParamsStruct.behaviors.labelcolors; %#ok<*PROP>
        nbehaviors = numel(basicParamsStruct.behaviors.names);
        assert(numel(labelcolors)==3*nbehaviors);        
        if size(labelcolors,2)~=3
          labelcolors = reshape(labelcolors,[3,nbehaviors])';
        end
        self.labelcolors = labelcolors;
        
        % ALTODO Update JLD.labelcolors. The JLD prop is not used but is
        % saved to the JAB file. Consider cleaning up this duplicated
        % param.
        self.data.labelcolors = self.labelcolors;
      
%         else
%           uiwait(warndlg('Error parsing label colors from config file, automatically assigning','Error parsing config label colors'));
%           if isfield(basicParamsStruct,'labels') && ...
%               isfield(basicParamsStruct.labels,'colormap'),
%             cm = basicParamsStruct.labels.colormap;
%           else
%             cm = 'lines';
%           end
%           if ~exist(cm,'file'),
%             cm = 'lines';
%           end
%       %     try
%             self.labelcolors = eval(sprintf('%s(%d)',cm,self.data.nbehaviors));
%       %     catch ME,
%       %       uiwait(warndlg(sprintf('Error using label colormap from config file: %s',getReport(ME)),'Error parsing config label colors'));
%       %       self.labelcolors = lines(self.data.nbehaviors);
%       %     end
%         end
      end
      
      self.labelunknowncolor = [0,0,0];
      if isfield(basicParamsStruct,'behaviors') && ...
         isfield(basicParamsStruct.behaviors,'unknowncolor'),
        unknowncolor = basicParamsStruct.behaviors.unknowncolor;
        if ischar(unknowncolor),
          unknowncolor = str2double(strsplit(unknowncolor,','));
          self.labelunknowncolor = unknowncolor;
        end        
        if numel(unknowncolor) >= 3,
          self.labelunknowncolor = reshape(unknowncolor(1:3),[1,3]);
        else
          uiwait(warndlg('Error parsing unknown color from config file, automatically assigning', ...
                         'Error parsing config unknown colors'));
        end
      end
      
      % scorecolor init
      scorecolor = cell(self.data.nclassifiers,1);
      for iCls = 1:self.data.nclassifiers
        iLbls = self.data.iCls2iLbl{iCls};
        sc = nan(63,3,3);
        for channel = 1:3
          startValue = self.labelcolors(iLbls(2),channel);
          endValue = self.labelcolors(iLbls(1),channel);
          midValue = self.labelunknowncolor(channel);
          
          sc(1:32,channel,1) = (midValue-startValue)*(0:31)/31+startValue;
          sc(32:63,channel,1) = (endValue-midValue)*(0:31)/31+midValue;
        end
        for ndx = 1:63
          sc(ndx,:,2) = ShiftColor.shiftColorFwd(sc(ndx,:,1));
          sc(ndx,:,3) = ShiftColor.shiftColorBkwd(sc(ndx,:,1));  
        end
        scorecolor{iCls} = sc;
      end
      self.scorecolor = scorecolor;

      self.correctcolor = [0,.7,0];
      self.incorrectcolor = [.7,.7,0];
      self.suggestcolor = [0,.7,.7];

      self.selection_color = [1,.6,0];
      self.selection_alpha = .5;

      % color for showing which labels are being plotted
      self.emphasiscolor = [.7,.7,0];
      self.unemphasiscolor = [1,1,1];

      % timeline properties
      self.timeline_prop_remove_string = '<html><body><i>Remove</i></body></html>';
      self.timeline_prop_help_string = '<html><body><i>Help</i></body></html>';
      self.timeline_prop_options = ...
        {self.timeline_prop_remove_string,...
        self.timeline_prop_help_string};

      if ~isempty(self.data.allperframefns)
        for i = 1:numel(self.data.allperframefns),
          self.timeline_prop_options{end+1} = self.data.allperframefns{i};
        end
        self.d = self.data.allperframefns(1);
        self.perframepropis = 1;
        %set(handles.timeline_label_prop1,'String',self.timeline_prop_options,'Value',3);
        self.timeline_data_ylims = nan(2,numel(self.data.allperframefns));
      end

      % maximum distance squared in fraction of axis to change frames when
      % clicking on preview window
      self.max_click_dist_preview = .005^2;

      % zoom state
      self.zoom_fly_radius = nan(1,2);
  
      % last clicked object
      self.selection_t0 = nan;
      self.selection_t1 = nan;
      self.selected_ts = nan(1,2);
      self.buttondown_t0 = nan;
      self.buttondown_axes = nan;

      % not selecting
      self.selecting = false;

      % initialize nextjump obj;
      self.NJObj = NextJump();
      self.NJObj.SetSeekBehaviorsGo(1:self.data.nbehaviors);
      self.NJObj.SetPerframefns(self.data.allperframefns);
      if isfield(self.rc,'navPreferences')  && ~isempty(self.rc.navPreferences)
        self.NJObj.SetState(self.rc.navPreferences);
      end

      % label shortcuts
      if numel(self.label_shortcuts) ~= 2*self.data.nbehaviors + 1,
        if self.data.nbehaviors == 2,
          self.label_shortcuts = {'z','a','x','s','c'}';
        else
          self.label_shortcuts = cellstr(num2str((1:2*self.data.nbehaviors+1)'));
        end
      end

      % play/stop
      self.hplaying = nan;

      % bookmarked clips windows
      self.bookmark_windows = [];

      self.doFastUpdates = true;
      
      if self.data.isMultiClassifier
        self.unsetClassifierFocus;
      else
        self.setClassifierFocus(1);
      end
    end
    
    function debugDumpLabelButtonState(obj)
      % debug routine
      
      hJAABA = findall(0,'type','figure','name','JAABA');
      gd = guidata(hJAABA);
      pnl = gd.panel_labelbuttons;
      hButton = findobj(pnl,'type','uicontrol');

      tb_behs = obj.togglebutton_label_behaviors;
      tb_unks = obj.togglebutton_unknown_behaviors;
      tb_unkAll = gd.togglebutton_label_unknown;
      tb_noneAll = obj.togglebutton_label_noneall;    

      %assert(all(ismember(hButton,[tb_behs(:);tb_unks(:);tb_unkAll(:)])));
    
      for i = 1:numel(tb_behs)
        if ~isnan(tb_behs(i))
          fprintf(1,'tbbeh %02d: %s %s %s %s\n',...
            i,get(tb_behs(i),'String'),get(tb_behs(i),'Tag'),...
            char(get(tb_behs(i),'Callback')),mat2str(get(tb_behs(i),'UserData')));
        end
      end
      for i = 1:numel(tb_unks)
        if ~isnan(tb_unks(i))
          fprintf(1,'tbunk %02d: %s %s %s %s\n',...
            i,get(tb_unks(i),'String'),get(tb_unks(i),'Tag'),...
            char(get(tb_unks(i),'Callback')),mat2str(get(tb_unks(i),'UserData')));
        end
      end
      if ~isnan(tb_unkAll)
        fprintf(1,'tbunk All: %s %s %s %s\n',...
          get(tb_unkAll,'String'),get(tb_unkAll,'Tag'),...
          char(get(tb_unkAll,'Callback')),mat2str(get(tb_unkAll,'UserData')));
      end
      if ~isnan(tb_noneAll)
        fprintf(1,'tbnone All: %s %s %s %s\n',...
          get(tb_noneAll,'String'),get(tb_noneAll,'Tag'),...
          char(get(tb_noneAll,'Callback')),mat2str(get(tb_noneAll,'UserData')));
      end
      
%          togglebutton_label_behaviors = []; 
%       % togglebutton handles for behavior-specific unknowns 
%     togglebutton_unknown_behaviors = [];
%     % convenience property, togglebutton_unknown_behaviors plus "Universal unknown" togglebutton
%     togglebutton_unknowns = []; 
%     
      
    end
    
  end  
  
  %%
  
  methods 
    
    function setClassifierFocus(self,iCls)
      self.behaviorFocusOn = true;
      self.behaviorFocusIdx = iCls;
      iLbls = self.data.iCls2iLbl{iCls};
      self.behaviorFocusLbls = iLbls;
      
      set(self.gdata.axes_timeline_auto,'ylim',[0.5 6.5]);
      self.updateAutoTimelineControls();
      self.updatePlotLabels();
    end
    
    function unsetClassifierFocus(self)
      self.behaviorFocusOn = false;
      self.behaviorFocusIdx = 0;
      self.behaviorFocusLbls = [nan nan];
      
      nCls = self.data.nclassifiers;
      set(self.gdata.axes_timeline_auto,'ylim',[0.5 nCls+0.5]);
      self.updateAutoTimelineControls();
      self.updatePlotLabels();
    end
    
    function updateAutoTimelineControls(self)
      if self.behaviorFocusOn
        set(self.auto_timeline_controls_behaviorFocusOn,'Visible','on');
        set(self.auto_timeline_controls_behaviorFocusOff,'Visible','off');
      else
        set(self.auto_timeline_controls_behaviorFocusOn,'Visible','off');
        set(self.auto_timeline_controls_behaviorFocusOff,'Visible','on');
      end
    end
    
    function setPlotLabelsManual(self)
      self.plot_labels_manual = true;
      self.plot_labels_automatic = false;
      self.updatePlotLabelsControls();
      self.updatePlotLabels();
    end
    
    function setPlotLabelsAutomatic(self)
      self.plot_labels_manual = false;
      self.plot_labels_automatic = true;
      self.updatePlotLabelsControls();
      self.updatePlotLabels();
    end
    
    function updatePlotLabelsControls(self)
      % Update uicontrols
      
      if self.plot_labels_manual
        set(self.gdata.menu_view_manual_labels,'Checked','on');
        set(self.gdata.timeline_label_manual, ...
          'Value',1,...
          'ForegroundColor',self.emphasiscolor, ...
          'FontWeight','bold');
      else
        set(self.gdata.menu_view_manual_labels,'Checked','off');
        set(self.gdata.timeline_label_manual, ...
          'Value',0,...
          'ForegroundColor',self.unemphasiscolor, ...
          'FontWeight','normal');
      end
      if self.plot_labels_automatic
        set(self.gdata.menu_view_automatic_labels,'Checked','on');
        set(self.gdata.timeline_label_automatic, ...
          'Value',1,...
          'ForegroundColor',self.emphasiscolor, ...
          'FontWeight','bold');
      else
        set(self.gdata.menu_view_automatic_labels,'Checked','off');
        set(self.gdata.timeline_label_automatic, ...
          'Value',0,...
          'ForegroundColor',self.unemphasiscolor, ...
          'FontWeight','normal');
      end
    end
    
    function updatePlotLabels(self)
      % Update plot lines/overlays
      
      % AL: legacy early return
      if ~self.data.getSomeExperimentIsCurrent()
        return;
      end
      
      if self.behaviorFocusOn
        iClsFoc = self.behaviorFocusIdx;
        iLbls = self.data.iCls2iLbl{iClsFoc};
        tfBehVis = false(1,self.data.nbehaviors);
        tfBehVis(iLbls) = true;
      else
        tfBehVis = true(1,self.data.nbehaviors);
      end
      
      if self.plot_labels_manual
        set(self.hlabels(tfBehVis),'Visible','on');
        set(self.hlabels(~tfBehVis),'Visible','off');
        set(self.hpredicted,'Visible','off');
      end
      if self.plot_labels_automatic
        set(self.hlabels,'Visible','off');
        set(self.hpredicted(tfBehVis),'Visible','on');
        set(self.hpredicted(~tfBehVis),'Visible','off');
      end
      
      % AL 20150219: seems like might be unnecessary, since all we have
      % done here is update Visibility of existing handles
      self.jlabelCall('UpdatePlots', ...
            'refreshim',false, ...
            'refreshflies',true, ...
            'refreshtrx',false, ...
            'refreshlabels',true,...
            'refresh_timeline_manual',false,...
            'refresh_timeline_auto',false,...
            'refresh_timeline_suggest',false,...
            'refresh_timeline_error',false,...
            'refresh_timeline_xlim',false,...
            'refresh_timeline_hcurr',false,...
            'refresh_timeline_props',false,...
            'refresh_timeline_selection',false,...
            'refresh_curr_prop',false);
    end
    
  end
  
  %% MISC
  
  methods
    
    function jlabelCall(self,fcn,varargin)
      handles = guidata(self.hJLabel);
      JLabel(fcn,handles,varargin{:});      
    end
    
  end
  
  methods (Static)
    
    function sel = getPopupSelection(hPUM)
      str = get(hPUM,'String');
      idx = get(hPUM,'Value');
      sel = str{idx};
    end
    
    function setPopupSelection(hPUM,strval)
      strs = get(hPUM,'String');
      tf = strcmp(strval,strs);
      assert(nnz(tf)==1,'String ''%s'' not valid menu selection.');
      set(hPUM,'Value',find(tf));
    end
    
  end
  
end
