import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myquran/src/feature/surah_detail/presentation/widget/appbar_detail_widget.dart';
import 'package:myquran/src/feature/surah_detail/presentation/widget/ayat_item.dart';
import 'package:myquran/src/feature/surah_detail/presentation/widget/detail_banner_widget.dart';

import '../../../../const/app_color.dart';
import '../../../all_surah/domain/model/surat_model.dart';
import '../bloc/ayat_bloc.dart';

class SurahDetailPage extends StatefulWidget {
  final SuratModel surat;

  const SurahDetailPage({Key? key, required this.surat}) : super(key: key);

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  @override
  void initState() {
    // context.read<AyatCubit>().getDetailSurat(widget.surat.nomor);
    context.read<AyatBloc>().add(GetAyatEvent(noSurat: widget.surat.nomor));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AyatBloc, AyatState>(
      builder: (context, state) {
        if (state is AyatLoading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is AyatLoaded) {
          var ayatSurat = state.detail;
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBarDetailWidget(
              surah: '${widget.surat.namaLatin}${widget.surat.nomor}',
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: DetailBannerWidget(
                    ayatSurat: ayatSurat,
                  ),
                )
              ],
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return AyatItem(
                      detail: ayatSurat,
                      index: index,
                    );
                  },
                  // _ayatItem(
                  //     ayat: surat.ayat!.elementAt(index + (noSurat == 1 ? 1 : 0))),
                  itemCount:
                      ayatSurat.jumlahAyat! + (ayatSurat.nomor == 1 ? -1 : 0),
                  separatorBuilder: (context, index) => Container(),
                ),
              ),
            ),
          );
        }
        if (state is AyatError) {
          return Scaffold(
            body: Center(
              child: Text(state.message),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text('No Data'),
          ),
        );
      },
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       '${widget.surat.namaLatin}${widget.surat.nomor}',
    //     ),
    //   ),
    //   body: BlocBuilder<AyatBloc, AyatState>(
    //     builder: (context, state) {
    //       if (state is AyatLoading) {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //       if (state is AyatLoaded) {
    //         return ListView.builder(
    //           itemCount: state.detail.ayat!.length,
    //           itemBuilder: (context, index) {
    //             final ayat = state.detail.ayat![index];
    //             return AyatItem(detail: state.detail, index: index);
    //             // return Card(
    //             //   child: ListTile(
    //             //     leading: CircleAvatar(
    //             //       backgroundColor: AppColors.primary,
    //             //       child: Text(
    //             //         '${index + 1}',
    //             //         style: const TextStyle(
    //             //             // color: AppColors.white,
    //             //             ),
    //             //       ),
    //             //     ),
    //             //     title: Text(
    //             //       '${ayat.ar}',
    //             //       textAlign: TextAlign.right,
    //             //       style: const TextStyle(
    //             //           fontSize: 24, fontWeight: FontWeight.bold),
    //             //     ),
    //             //     subtitle: Text(
    //             //       '${ayat.idn}',
    //             //     ),
    //             //   ),
    //             // );
    //           },
    //         );
    //       }
    //       if (state is AyatError) {
    //         return Center(
    //           child: Text(state.message),
    //         );
    //       }
    //       return const Center(
    //         child: Text('No Data'),
    //       );
    //     },
    //   ),
    // );
  }
}
