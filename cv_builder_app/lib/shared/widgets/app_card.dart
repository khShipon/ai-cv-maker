import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Custom App Card Widget
/// Provides consistent card styling with rounded corners and soft shadows
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final bool isSelected;
  final bool isHoverable;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.isSelected = false,
    this.isHoverable = false,
  });

  const AppCard.clickable({
    super.key,
    required this.child,
    required this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.isSelected = false,
  }) : isHoverable = true;

  const AppCard.selectable({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    required this.isSelected,
  }) : isHoverable = true;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? 
        (isSelected ? AppColors.primaryLight.withOpacity(0.1) : AppColors.surface);
    
    final effectiveElevation = elevation ?? (isSelected ? 4.0 : 2.0);
    
    final effectiveBorderRadius = borderRadius ?? 
        BorderRadius.circular(AppSpacing.radiusLg);
    
    final effectiveBorder = border ?? 
        (isSelected 
            ? Border.all(color: AppColors.primary, width: 2)
            : null);

    Widget card = Container(
      margin: margin ?? const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: effectiveBorder,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: effectiveElevation * 2,
            offset: Offset(0, effectiveElevation),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          hoverColor: isHoverable ? AppColors.primary.withOpacity(0.04) : null,
          splashColor: AppColors.primary.withOpacity(0.1),
          child: card,
        ),
      );
    } else if (isHoverable) {
      card = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: card,
      );
    }

    return AnimatedContainer(
      duration: AppConstants.shortAnimation,
      child: card,
    );
  }
}

/// Specialized card variants
class CVCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isSelected;
  final CVStatus status;

  const CVCard({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isSelected = false,
    this.status = CVStatus.draft,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.selectable(
      onTap: onTap,
      isSelected: isSelected,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _StatusChip(status: status),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class TemplateCard extends StatelessWidget {
  final String name;
  final String category;
  final String? previewUrl;
  final VoidCallback? onTap;
  final bool isSelected;

  const TemplateCard({
    super.key,
    required this.name,
    required this.category,
    this.previewUrl,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.selectable(
      onTap: onTap,
      isSelected: isSelected,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusLg),
                topRight: Radius.circular(AppSpacing.radiusLg),
              ),
            ),
            child: previewUrl != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusLg),
                      topRight: Radius.circular(AppSpacing.radiusLg),
                    ),
                    child: Image.network(
                      previewUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _TemplatePlaceholder(),
                    ),
                  )
                : const _TemplatePlaceholder(),
          ),
          
          // Template Info
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  category,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final CVStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case CVStatus.draft:
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        label = 'Draft';
        break;
      case CVStatus.complete:
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        label = 'Complete';
        break;
      case CVStatus.exported:
        backgroundColor = AppColors.info.withOpacity(0.1);
        textColor = AppColors.info;
        label = 'Exported';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TemplatePlaceholder extends StatelessWidget {
  const _TemplatePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusLg),
          topRight: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.description_outlined,
          size: AppSpacing.iconLg,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}

enum CVStatus {
  draft,
  complete,
  exported,
}
