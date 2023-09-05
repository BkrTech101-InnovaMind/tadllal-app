import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tedllal/model/real_estate.dart';
import 'package:tedllal/services/api/dio_api.dart';

class CommentDialog extends StatefulWidget {
  final double rating;
  final TextEditingController commentController;
  final String commentId;
  final VoidCallback syncData;
  final RealEstate realEstate;
  const CommentDialog(
      {required this.rating,
      required this.commentController,
      required this.commentId,
      required this.syncData,
      required this.realEstate,
      super.key});

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final DioApi dioApi = DioApi();
  double? rating;
  TextEditingController commentController = TextEditingController();
  RealEstate realEstate = RealEstate();
  String commentId = "";
  void _syncData() {
    widget.syncData();
  }

  @override
  void initState() {
    rating = widget.rating;
    commentController = widget.commentController;
    commentId = widget.commentId;
    realEstate = widget.realEstate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("ما رأيك في هذا العقار ؟"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Directionality(
            textDirection: TextDirection.ltr,
            child: RatingBar(
              initialRating: widget.rating,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              ratingWidget: RatingWidget(
                full: const Icon(Icons.star, color: Colors.amber),
                half: const Icon(Icons.star_half, color: Colors.amber),
                empty: const Icon(Icons.star_border, color: Colors.amber),
              ),
              onRatingUpdate: (value) {
                rating = value;
              },
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: commentController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(vertical: 25),
                hintText: "تعليقك",
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          height: 30.0,
          minWidth: 50.0,
          color: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashColor: Colors.redAccent,
          child: const Text(
            'إلغاء',
            style: TextStyle(fontSize: 12),
          ),
        ),
        MaterialButton(
          height: 30.0,
          minWidth: 50.0,
          color: const Color(0xFF8BC83F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          textColor: Colors.white,
          onPressed: () {
            if (commentController.text.isEmpty) {
              Navigator.pop(context);
              return;
            } else {
              if (commentId.isEmpty) {
                dioApi.post("/comments/add/${realEstate.id}", myData: {
                  "comment": commentController.text.trim()
                }).then((value) {
                  commentController.clear();
                  _syncData();
                });
              } else {
                dioApi.put("/comments/comment/$commentId", myData: {
                  "comment": commentController.text.trim()
                }).then((value) {
                  commentController.clear();
                  commentId = "";
                  _syncData();
                });
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
              "تم التعليق بنجاح",
            )));
            Navigator.of(context).pop();
          },
          splashColor: const Color(0xFF8BC83F),
          child: const Text(
            'تعليق',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
