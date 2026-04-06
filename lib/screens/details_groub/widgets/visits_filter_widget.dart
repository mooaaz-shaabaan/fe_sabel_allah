import 'package:flutter/material.dart';
import '../../../model/member_model.dart';

enum VisitFilter { most, least, newest }

class VisitsFilterWidget extends StatelessWidget {
  final VisitFilter selected;
  final ValueChanged<VisitFilter> onChanged;

  const VisitsFilterWidget({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ترتيب الزيارات',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _FilterButton(
                  label: 'الأكثر زيارات',
                  icon: Icons.arrow_upward_rounded,
                  isSelected: selected == VisitFilter.most,
                  onTap: () => onChanged(VisitFilter.most),
                ),
                const SizedBox(width: 8),
                _FilterButton(
                  label: 'الأقل زيارات',
                  icon: Icons.arrow_downward_rounded,
                  isSelected: selected == VisitFilter.least,
                  onTap: () => onChanged(VisitFilter.least),
                ),
                const SizedBox(width: 8),
                _FilterButton(
                  label: 'أحدث زيارات',
                  icon: Icons.access_time_rounded,
                  isSelected: selected == VisitFilter.newest,
                  onTap: () => onChanged(VisitFilter.newest),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEEEDFE) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF7F77DD)
                  : const Color(0xFFDDDDDD),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? const Color(0xFF3C3489) : Colors.grey,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? const Color(0xFF3C3489)
                        : Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper: ترتيب القائمة حسب الفلتر ──────────────────────────────
List<MembersModel> sortMembersByFilter(
  List<MembersModel> members,
  VisitFilter filter,
) {
  final sorted = List<MembersModel>.from(members);

  switch (filter) {
    case VisitFilter.most:
      sorted.sort(
        (a, b) => (b.allTimeVisted?.length ?? 0)
            .compareTo(a.allTimeVisted?.length ?? 0),
      );
      break;

    case VisitFilter.least:
      sorted.sort(
        (a, b) => (a.allTimeVisted?.length ?? 0)
            .compareTo(b.allTimeVisted?.length ?? 0),
      );
      break;

    case VisitFilter.newest:
      sorted.sort((a, b) {
        final aDate = _latestVisit(a);
        final bDate = _latestVisit(b);
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return bDate.compareTo(aDate);
      });
      break;
  }

  return sorted;
}

DateTime? _latestVisit(MembersModel member) {
  if (member.allTimeVisted == null || member.allTimeVisted!.isEmpty) {
    return null;
  }
  return member.allTimeVisted!
      .map((e) => DateTime.tryParse(e))
      .whereType<DateTime>()
      .fold<DateTime?>(
        null,
        (prev, d) => prev == null || d.isAfter(prev) ? d : prev,
      );
}