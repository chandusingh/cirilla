import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product_category/product_category.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui/notification/notification_screen.dart';

import 'body.dart';
import 'list_category_scroll_load_more.dart';

/// Vertical layout category
class VerticalCategory extends Body with LoadingMixin, Utility, ContainerMixin {
  const VerticalCategory({
    Key? key,
    List<ProductCategory>? categories,
    WidgetConfig? widgetConfig,
    Map<String, dynamic>? configs,
    String themeModeKey = "value",
    String languageKey = "text",
    String imageKey = "src",
  }) : super(
          key: key,
          categories: categories,
          widgetConfig: widgetConfig,
          configs: configs,
          languageKey: languageKey,
          themeModeKey: themeModeKey,
          imageKey: imageKey,
        );

  List<ProductCategory?>? getListItem(ProductCategory? parent, enableShowAll, positionShowAll) {
    if (enableShowAll) {
      if (positionShowAll == 'start') {
        return [parent, ...parent!.categories!];
      } else {
        return [...parent!.categories!, parent];
      }
    }
    return parent?.categories;
  }

  @override
  Widget buildBody(
    BuildContext context, {
    Widget? appBar,
    Widget? tab,
    ProductCategory? parent,
    Widget? banner,
    WidgetConfig? widgetConfig,
    String languageKey = "text",
    String themeModeKey = "src",
  }) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Color background =
        ConvertData.fromRGBA(get(widgetConfig!.styles, ['backgroundItems', themeModeKey], {}), Colors.white);

    // Config style view
    String? layoutView = get(widgetConfig.fields, ['styleView'], Strings.layoutCategoryList);
    int col = ConvertData.stringToInt(get(widgetConfig.fields, ['columnGrid'], 2), 2);
    double? ratio = ConvertData.stringToDouble(get(widgetConfig.fields, ['childAspectRatio'], 1), 1);

    // Config item show all
    bool enableShowAll = get(widgetConfig.fields, ['enableShowAll'], true);
    bool? enableChangeNameShowAll = get(widgetConfig.fields, ['enableChangeNameShowAll'], true);
    String? positionShowAll = get(widgetConfig.fields, ['positionShowAll'], 'start');
    String? textShowAll =
        get(widgetConfig.fields, ['textShowAll', languageKey], translate('product_category_show_all'));

    double? pad = ConvertData.stringToDouble(get(widgetConfig.fields, ['padItem'], 16));
    Map<String, dynamic>? template =
        get(widgetConfig.fields, ['template'], {'template': Strings.productCategoryItemHorizontal, 'data': {}});

    return Scaffold(
      appBar: appBar as PreferredSizeWidget?,
      body: Column(
        children: [
          banner ?? Container(),
          if (categories?.isNotEmpty != true)
            Expanded(
              child: NotificationScreen(
                title: Text(
                  translate('product_category'),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  translate('product_category_no_found'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                iconData: FeatherIcons.grid,
                isButton: false,
              ),
            )
          else
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tab!,
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      color: background,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: paddingMedium,
                            sliver: ListCategoryScrollLoadMore(
                              categories: getListItem(parent, enableShowAll, positionShowAll),
                              layout: layoutView,
                              col: col,
                              ratio: ratio,
                              enableTextShowAll: enableChangeNameShowAll,
                              textShowAll: textShowAll,
                              idShowAll: parent?.id,
                              template: template,
                              styles: widgetConfig.styles ?? {},
                              pad: pad,
                              themeModeKey: themeModeKey,
                            ),
                            // sliver: SliverToBoxAdapter(
                            //   child: Text('Vertical'),
                            // ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget buildTabs(
    BuildContext context, {
    TabController? tabController,
    List<ProductCategory>? categories,
    Function? onChanged,
    WidgetConfig? widgetConfig,
  }) {
    ThemeData theme = Theme.of(context);
    Color background =
        ConvertData.fromRGBA(get(widgetConfig!.styles, ['backgroundItems', themeModeKey], {}), Colors.white);

    bool isRTL = Directionality.of(context).toString().contains(TextDirection.RTL.value.toLowerCase());
    int quarterTurnsBox = isRTL ? 3 : 1;
    int quarterTurnsItem = isRTL ? 1 : 3;
    Map<String, dynamic> styles = widgetConfig.styles ?? {};
    double sizeText = ConvertData.stringToDouble(get(styles, ['sizeText'], 16));

    return SizedBox(
      width: tabVerticalWidth,
      height: double.infinity,
      child: RotatedBox(
        quarterTurns: quarterTurnsBox,
        child: TabBar(
          onTap: onChanged as void Function(int)?,
          labelPadding: EdgeInsets.zero,
          indicatorWeight: 0,
          isScrollable: true,
          labelColor: theme.primaryColor,
          controller: tabController,
          labelStyle: theme.textTheme.bodyLarge,
          unselectedLabelColor: theme.textTheme.bodyLarge?.color,
          indicator: BoxDecoration(
            color: background,
            border: Border(bottom: BorderSide(width: 4, color: Theme.of(context).primaryColor)),
          ),
          tabs: List.generate(
            categories!.length,
            (inx) => RotatedBox(
              quarterTurns: quarterTurnsItem,
              child: Container(
                width: double.infinity,
                padding: paddingHorizontalMedium.add(paddingVertical),
                child: Text(
                  categories[inx].name!,
                  style: TextStyle(fontSize: sizeText),
                ),
              ),
            ),
          ).toList(),
        ),
      ),
    );
  }

  // Build Layout App bar
  @override
  Widget? buildAppBar(BuildContext context, {Map<String, dynamic>? configs}) {
    // String type = get(configs, ['appBarType'], Strings.appbarFloating);
    bool enableSearch = get(configs, ['enableSearch'], true);
    bool? enableCart = get(configs, ['enableCart'], true);

    if (!enableSearch && !enableCart!) {
      return null;
    }

    // ==== Title
    Widget? title = enableSearch ? const SearchProductWidget() : null;

    // ==== Actions
    List<Widget> actions = [
      if (enableCart!)
        const Padding(
          padding: EdgeInsetsDirectional.only(end: 17),
          child: CirillaCartIcon(
            icon: Icon(FeatherIcons.shoppingCart),
            enableCount: true,
            color: Colors.transparent,
          ),
        ),
    ];
    return AppBar(
      elevation: 0,
      primary: true,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: title,
      actions: actions,
      titleSpacing: 20,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(16),
        child: Container(),
      ),
    );
  }

  // Build Banner
  @override
  Widget? buildBanner(
    BuildContext context, {
    Map<String, dynamic>? configs,
    required String imageKey,
    String themeModeKey = "value",
  }) {
    bool enableBanner = get(configs, ['enableBanner'], true);

    if (!enableBanner) {
      return null;
    }
    Map<String, dynamic>? background = get(configs, ['backgroundBanner', themeModeKey], null);
    return Container(
      padding: paddingHorizontal.copyWith(bottom: itemPaddingMedium),
      decoration: decorationColorImage(
        color: ConvertData.fromRGBA(background, Colors.transparent),
      ),
      child: BannerWidget(configs: configs, imageKey: imageKey),
    );
  }
}
