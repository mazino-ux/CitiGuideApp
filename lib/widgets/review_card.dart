import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewCard extends StatefulWidget {
  final Map<String, dynamic> review;
  final VoidCallback onReviewUpdated;
  final VoidCallback onReviewDeleted;

  const ReviewCard({
    super.key,
    required this.review,
    required this.onReviewUpdated,
    required this.onReviewDeleted,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  final _supabase = Supabase.instance.client;
  bool _isEditing = false;
  late TextEditingController _editController;
  late double _editRating;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.review['comment']);
    _editRating = (widget.review['rating'] as num).toDouble();
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  Future<void> _deleteReview() async {
    try {
      await _supabase
          .from('reviews')
          .delete()
          .eq('id', widget.review['id']);
      widget.onReviewDeleted();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete review: ${e.toString()}')),
      );
    }
  }

  Future<void> _updateReview() async {
    try {
      await _supabase
          .from('reviews')
          .update({
            'comment': _editController.text,
            'rating': _editRating,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', widget.review['id']);
      
      setState(() => _isEditing = false);
      widget.onReviewUpdated();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update review: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.review['profiles'] ?? {};
    final date = widget.review['created_at'] != null 
        ? DateTime.parse(widget.review['created_at']) 
        : DateTime.now();
    final isCurrentUser = _supabase.auth.currentUser?.id == widget.review['user_id'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: profile['avatar_url'] != null
                      ? NetworkImage(profile['avatar_url'])
                      : null,
                  child: profile['avatar_url'] == null
                      ? Text((profile['username']?[0] ?? 'U').toUpperCase())
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile['username'] ?? 'Anonymous',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${date.day}/${date.month}/${date.year}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrentUser) ...[
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () => setState(() => _isEditing = true),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: _deleteReview,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            if (!_isEditing) ...[
              Row(
                children: [
                  ...List.generate(5, (index) => Icon(
                    index < _editRating ? Icons.star : Icons.star_border,
                    size: 16,
                    color: Colors.amber,
                  )),
                  const SizedBox(width: 8),
                  Text(_editRating.toStringAsFixed(1)),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.review['comment']),
            ] else ...[
              TextField(
                controller: _editController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ...List.generate(5, (index) => IconButton(
                    icon: Icon(
                      index < _editRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => _editRating = index + 1.0),
                  )),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() => _isEditing = false),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _updateReview,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}