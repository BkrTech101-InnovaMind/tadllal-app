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

  void _ratingPost() {
    dioApi.post(
      "/realEstate/rate",
      myData: {
        "id": realEstate.id,
        "rate": rating,
      },
    ).then((value) => _syncData());
  }

  void _commentPost() {
    dioApi.post("/comments/add/${realEstate.id}",
        myData: {"comment": commentController.text.trim()}).then(
      (value) {
        commentController.clear();
        _syncData();
      },
    );
  }

  void _commentEdit() {
    dioApi.put("/comments/comment/$commentId",
        myData: {"comment": commentController.text.trim()}).then(
      (value) {
        commentController.clear();
        commentId = "";
        _syncData();
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _onPressed() {
    final String comment = commentController.text;
    if (comment.isNotEmpty && rating != 0) {
      if (commentId.isEmpty) {
        _ratingPost();
        _commentPost();
        Navigator.pop(context);
        _showSnackBar("تم الإرسال بنجاح");
      } else {
        _commentEdit();
        Navigator.pop(context);
        _showSnackBar("تم التعديل بنجاح");
      }
    } else if (comment.isNotEmpty) {
      if (commentId.isEmpty) {
        _commentPost();
        Navigator.pop(context);
        _showSnackBar("تم التعليق بنجاح");
      } else {
        _commentEdit();
        Navigator.pop(context);
        _showSnackBar("تم التعديل بنجاح");
      }
    } else if (rating != 0) {
      _ratingPost();
      Navigator.pop(context);
      _showSnackBar("تم التقييم بنجاح");
    } else {
      Navigator.pop(context);
      _showSnackBar("لا توجد بيانات للتقييم!! ");
    }
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
              allowHalfRating: false,
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
              keyboardType: TextInputType.text,
              maxLines: 6,
              minLines: 1,
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
          onPressed: () => _onPressed(),
          splashColor: const Color(0xFF8BC83F),
          child: const Text(
            'تقييم',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
