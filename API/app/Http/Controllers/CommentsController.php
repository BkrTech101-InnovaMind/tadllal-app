<?php

namespace App\Http\Controllers;

use App\Models\RealEstate;
use App\Models\UserComment;
use Illuminate\Http\Request;
use App\Traits\HttpResponses;
use Illuminate\Support\Facades\Auth;

class CommentsController extends Controller
{
    use HttpResponses;
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request, RealEstate $realEstate)
    {
        $validatedData = $request->validate([
            'comment' => 'required|string',
        ]);

        $comment = new UserComment([
            'user_id' => auth()->user()->id,
            'comment' => $validatedData['comment'],
        ]);

        $realEstate->comments()->save($comment);

        return $this->success([
        ], 'Comment added successfully');
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, UserComment $comment)
    {
        $validatedData = $request->validate([
            'comment' => 'required|string',
        ]);

        $comment->update([
            'comment' => $validatedData['comment'],
        ]);

        return $this->success([
            'commennt' => $comment,
        ], 'Comment updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(UserComment $comment)
    {
        if (!$comment) {
            return $this->error('', 'type not found', 404);
        } else {
            $comment->delete();

            return $this->success([
                'message' => 'Comment deleted successfully',
            ]);

        }
    }
}