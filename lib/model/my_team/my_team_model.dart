class MyTeamSummaryModel {
  final String totalMembers;
  final String departments;
  final String newJoiners;
  final String probation;

  MyTeamSummaryModel({
    required this.totalMembers,
    required this.departments,
    required this.newJoiners,
    required this.probation,
  });
}

enum TeamMemberStatusType { leave, present }

class TeamMemberModel {
  final String id;
  final String name;
  final String initials;
  final String role;
  final String statusText;
  final TeamMemberStatusType statusType;

  TeamMemberModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.role,
    required this.statusText,
    required this.statusType,
  });
}
