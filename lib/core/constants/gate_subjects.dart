/// GATE DA (Data Science & AI) subjects with their respective weightage and topic counts.
class GateSubjects {
  GateSubjects._();

  static const List<Map<String, dynamic>> subjects = [
    {
      'id': 'prob_stats',
      'name': 'Probability & Statistics',
      'weightage': 'high',
      'icon': 'bar_chart',
      'totalTopics': 25,
    },
    {
      'id': 'lin_alg',
      'name': 'Linear Algebra',
      'weightage': 'high',
      'icon': 'matrix',
      'totalTopics': 18,
    },
    {
      'id': 'calculus',
      'name': 'Calculus',
      'weightage': 'medium',
      'icon': 'functions',
      'totalTopics': 12,
    },
    {
      'id': 'ml_ai',
      'name': 'ML & AI',
      'weightage': 'high',
      'icon': 'psychology',
      'totalTopics': 30,
    },
    {
      'id': 'prog_dsa',
      'name': 'Programming / DSA / Python',
      'weightage': 'medium',
      'icon': 'code',
      'totalTopics': 20,
    },
    {
      'id': 'dbms',
      'name': 'Databases',
      'weightage': 'medium',
      'icon': 'storage',
      'totalTopics': 15,
    },
    {
      'id': 'aptitude',
      'name': 'Aptitude',
      'weightage': 'medium',
      'icon': 'lightbulb',
      'totalTopics': 12,
    },
  ];
}
