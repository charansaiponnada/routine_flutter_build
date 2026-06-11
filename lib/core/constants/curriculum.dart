enum CourseType { roadmap, gate }

class CourseModule {
  final String id;
  final String title;
  final String? videoUrl;
  final int estimatedMinutes;

  const CourseModule({
    required this.id,
    required this.title,
    this.videoUrl,
    this.estimatedMinutes = 0,
  });
}

class RoadmapCourse {
  final String id;
  final String name;
  final String description;
  final CourseType type;
  final String icon;
  final List<CourseModule> modules;
  final String? playlistUrl;
  final String? resourceUrl;

  int get totalModules => modules.length;

  const RoadmapCourse({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.icon,
    required this.modules,
    this.playlistUrl,
    this.resourceUrl,
  });
}

class Curriculum {
  Curriculum._();

  static const List<RoadmapCourse> courses = [
    _mathFoundations,
    _practicalDL,
    _introML,
    _zeroToHero,
    _transformerArch,
    _stanfordAcademics,
    _gateDA,
  ];

  static const _mathFoundations = RoadmapCourse(
    id: 'math_foundations',
    name: 'Math Foundations',
    description: 'Probability, Linear Algebra & Calculus via 3Blue1Brown',
    type: CourseType.roadmap,
    icon: 'functions',
    playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab',
    modules: [
      CourseModule(
        id: 'prob_bayes',
        title: 'Probability — Bayes & Monty Hall',
        videoUrl: 'https://www.youtube.com/watch?v= video_id_placeholder',
        estimatedMinutes: 45,
      ),
      CourseModule(
        id: 'prob_distributions',
        title: 'Probability — Binomial & Distributions',
        estimatedMinutes: 45,
      ),
      CourseModule(
        id: 'prob_clt',
        title: 'Probability — Central Limit Theorem',
        estimatedMinutes: 45,
      ),
      CourseModule(
        id: 'la_vectors',
        title: 'LA — Vectors, Span & Basis',
        videoUrl: 'https://www.youtube.com/watch?v=fNk_zzaMoSs',
        estimatedMinutes: 30,
      ),
      CourseModule(
        id: 'la_transforms',
        title: 'LA — Linear Transformations & Matrices',
        videoUrl: 'https://www.youtube.com/watch?v=kYB8IZa5AuE',
        estimatedMinutes: 30,
      ),
      CourseModule(
        id: 'la_eigen',
        title: 'LA — Determinants, Eigenvectors & Eigenvalues',
        videoUrl: 'https://www.youtube.com/watch?v=Ip3X9LOh2dk',
        estimatedMinutes: 45,
      ),
      CourseModule(
        id: 'calc_derivatives',
        title: 'Calculus — Derivatives & Chain Rule',
        videoUrl: 'https://www.youtube.com/watch?v=WUvTyaaNkzM',
        estimatedMinutes: 30,
      ),
      CourseModule(
        id: 'calc_integrals',
        title: 'Calculus — Limits, Integrals & Area',
        estimatedMinutes: 30,
      ),
      CourseModule(
        id: 'calc_taylor',
        title: 'Calculus — Taylor Series & Higher Dimensions',
        estimatedMinutes: 30,
      ),
    ],
  );

  static const _practicalDL = RoadmapCourse(
    id: 'practical_dl',
    name: 'Practical Deep Learning',
    description: 'fast.ai Practical Deep Learning for Coders 2022',
    type: CourseType.roadmap,
    icon: 'smart_display',
    playlistUrl: 'https://www.youtube.com/playlist?list=PLfYUBJiXbdtSvpQjSnJJ_PmDQB_VyT5iU',
    modules: [
      CourseModule(
        id: 'dl_getting_started',
        title: 'Getting Started with Image Classification',
        videoUrl: 'https://course.fast.ai/Lessons/lesson1.html',
        estimatedMinutes: 90,
      ),
      CourseModule(
        id: 'dl_deployment',
        title: 'Deployment to Web Apps',
        estimatedMinutes: 90,
      ),
      CourseModule(
        id: 'dl_nn_foundations',
        title: 'Neural Net Foundations (SGD, ReLU)',
        estimatedMinutes: 90,
      ),
      CourseModule(
        id: 'dl_nlp',
        title: 'Natural Language Processing',
        estimatedMinutes: 90,
      ),
      CourseModule(
        id: 'dl_from_scratch',
        title: 'From-Scratch Model Building',
        estimatedMinutes: 90,
      ),
      CourseModule(
        id: 'dl_random_forests',
        title: 'Random Forests & Decision Trees',
        estimatedMinutes: 90,
      ),
      CourseModule(
        id: 'dl_regressions',
        title: 'Regressions & Initializations',
        estimatedMinutes: 90,
      ),
      CourseModule(
        id: 'dl_augmentation',
        title: 'Data Augmentation & ResNets',
        estimatedMinutes: 90,
      ),
      CourseModule(
        id: 'dl_inside_model',
        title: 'Looking Inside the Model',
        estimatedMinutes: 90,
      ),
    ],
  );

  static const _introML = RoadmapCourse(
    id: 'intro_ml',
    name: 'Intro to ML for Coders',
    description: 'fast.ai Introduction to Machine Learning',
    type: CourseType.roadmap,
    icon: 'insights',
    playlistUrl: 'https://www.youtube.com/playlist?list=PLfYUBJiXbdtSyktd8A_x0JNd6lxDcZE96',
    modules: [
      CourseModule(
        id: 'ml_rf_deep',
        title: 'Random Forests Deep Dive',
        estimatedMinutes: 90,
      ),
      CourseModule(
        id: 'ml_feature_eng',
        title: 'Feature Engineering & Cleaning',
        estimatedMinutes: 90,
      ),
      CourseModule(
        id: 'ml_gradient_boost',
        title: 'Gradient Boosting',
        estimatedMinutes: 90,
      ),
      CourseModule(
        id: 'ml_ethics',
        title: 'Ethics & Data Quality',
        estimatedMinutes: 60,
      ),
      CourseModule(
        id: 'ml_interpretation',
        title: 'Model Interpretation',
        estimatedMinutes: 90,
      ),
      CourseModule(
        id: 'ml_production',
        title: 'Production Deployment',
        estimatedMinutes: 60,
      ),
    ],
  );

  static const _zeroToHero = RoadmapCourse(
    id: 'zero_to_hero',
    name: 'Neural Networks: Zero to Hero',
    description: 'Andrej Karpathy — build NNs from scratch in code',
    type: CourseType.roadmap,
    icon: 'bolt',
    playlistUrl: 'https://www.youtube.com/playlist?list=PLAqhIrjkxbuWI23v9cThsA9GvCAUhRvKZ',
    modules: [
      CourseModule(
        id: 'micrograd',
        title: 'Micrograd: Backprop Engine',
        videoUrl: 'https://www.youtube.com/watch?v=VMj-3S1tku0',
        estimatedMinutes: 145,
      ),
      CourseModule(
        id: 'makemore_bigram',
        title: 'Makemore: Bigram Language Model',
        videoUrl: 'https://www.youtube.com/watch?v=PaCmpygFfXo',
        estimatedMinutes: 117,
      ),
      CourseModule(
        id: 'makemore_mlp',
        title: 'MLP Language Model (Bengio 2003)',
        videoUrl: 'https://www.youtube.com/watch?v=TCH_1BHY58I',
        estimatedMinutes: 75,
      ),
      CourseModule(
        id: 'makemore_batchnorm',
        title: 'Activations, Gradients & BatchNorm',
        videoUrl: 'https://www.youtube.com/watch?v=P6sfmUTpUmc',
        estimatedMinutes: 115,
      ),
      CourseModule(
        id: 'backprop_ninja',
        title: 'Becoming a Backprop Ninja',
        videoUrl: 'https://www.youtube.com/watch?v=q8SA3rM6ckI',
        estimatedMinutes: 115,
      ),
      CourseModule(
        id: 'wavenet',
        title: 'Building a WaveNet',
        videoUrl: 'https://www.youtube.com/watch?v=t3YJ5hKiMQ0',
        estimatedMinutes: 56,
      ),
      CourseModule(
        id: 'gpt_scratch',
        title: 'Building GPT from Scratch',
        videoUrl: 'https://www.youtube.com/watch?v=kCc8FmEb1nY',
        estimatedMinutes: 116,
      ),
      CourseModule(
        id: 'state_of_gpt',
        title: 'State of GPT',
        estimatedMinutes: 42,
      ),
      CourseModule(
        id: 'gpt_tokenizer',
        title: 'GPT Tokenizer (BPE)',
        videoUrl: 'https://www.youtube.com/watch?v=zduSFxRajkE',
        estimatedMinutes: 133,
      ),
      CourseModule(
        id: 'reproduce_gpt2',
        title: 'Reproducing GPT-2 (124M)',
        videoUrl: 'https://www.youtube.com/watch?v=l8pRSuU81PU',
        estimatedMinutes: 241,
      ),
    ],
  );

  static const _transformerArch = RoadmapCourse(
    id: 'transformer_arch',
    name: 'Transformer Architectures',
    description: 'Umar Jamil — Transformers, Positional Encoding & Vision Models',
    type: CourseType.roadmap,
    icon: 'linear_scale',
    modules: [
      CourseModule(
        id: 'attention_mechanism',
        title: 'How Attention Mechanism Works',
        videoUrl: 'https://www.youtube.com/@UmarJamil',
        estimatedMinutes: 60,
      ),
      CourseModule(
        id: 'positional_encoding',
        title: 'Positional Encoding',
        estimatedMinutes: 45,
      ),
      CourseModule(
        id: 'transformer_deep',
        title: 'Transformer Architecture Deep Dive',
        estimatedMinutes: 90,
      ),
      CourseModule(
        id: 'vision_transformers',
        title: 'Vision Transformers (ViT)',
        estimatedMinutes: 60,
      ),
      CourseModule(
        id: 'llms_internals',
        title: 'How LLMs Work',
        estimatedMinutes: 60,
      ),
    ],
  );

  static const _stanfordAcademics = RoadmapCourse(
    id: 'stanford_academics',
    name: 'Stanford Academics',
    description: 'CS229 · CS231n · CS336 — ML, CV & Language Modeling',
    type: CourseType.roadmap,
    icon: 'school',
    modules: [
      CourseModule(
        id: 'cs229_supervised',
        title: 'CS229: Supervised Learning (Regression, Classification)',
        estimatedMinutes: 120,
      ),
      CourseModule(
        id: 'cs229_svm',
        title: 'CS229: SVMs & Kernels',
        estimatedMinutes: 120,
      ),
      CourseModule(
        id: 'cs229_nn',
        title: 'CS229: Neural Networks & Backprop',
        estimatedMinutes: 120,
      ),
      CourseModule(
        id: 'cs229_unsupervised',
        title: 'CS229: Unsupervised Learning',
        estimatedMinutes: 120,
      ),
      CourseModule(
        id: 'cs231n_cnn',
        title: 'CS231n: Image Classification & CNNs',
        estimatedMinutes: 120,
      ),
      CourseModule(
        id: 'cs231n_arch',
        title: 'CS231n: ConvNet Architectures',
        estimatedMinutes: 120,
      ),
      CourseModule(
        id: 'cs231n_attention',
        title: 'CS231n: Attention & Transformers for Vision',
        estimatedMinutes: 120,
      ),
      CourseModule(
        id: 'cs336_lm',
        title: 'CS336: Language Modeling Foundations',
        estimatedMinutes: 120,
      ),
      CourseModule(
        id: 'cs336_scaling',
        title: 'CS336: Scaling Laws & Alignment',
        estimatedMinutes: 120,
      ),
    ],
  );

  static const _gateDA = RoadmapCourse(
    id: 'gate_da',
    name: 'GATE DA',
    description: 'Data Science & AI — 7 subjects for GATE 2027',
    type: CourseType.gate,
    icon: 'workspace_premium',
    modules: [
      CourseModule(
        id: 'prob_stats',
        title: 'Probability & Statistics',
        estimatedMinutes: 1500,
      ),
      CourseModule(
        id: 'lin_alg',
        title: 'Linear Algebra',
        estimatedMinutes: 1080,
      ),
      CourseModule(
        id: 'calculus',
        title: 'Calculus',
        estimatedMinutes: 720,
      ),
      CourseModule(
        id: 'ml_ai',
        title: 'ML & AI',
        estimatedMinutes: 1800,
      ),
      CourseModule(
        id: 'prog_dsa',
        title: 'Programming / DSA / Python',
        estimatedMinutes: 1200,
      ),
      CourseModule(
        id: 'dbms',
        title: 'Databases',
        estimatedMinutes: 900,
      ),
      CourseModule(
        id: 'aptitude',
        title: 'Aptitude',
        estimatedMinutes: 720,
      ),
    ],
  );
}
