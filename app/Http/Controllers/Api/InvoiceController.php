<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\SerializesCateringData;
use App\Models\Invoice;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class InvoiceController
{
    use SerializesCateringData;

    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        $invoices = Invoice::query()
            ->whereHas('order', function ($query) use ($user) {
                if ($user->isMerchant()) {
                    $query->where('caterer_id', $user->id);
                } else {
                    $query->where('office_id', $user->id);
                }
            })
            ->with(['order.caterer', 'order.office', 'order.items', 'order.invoice'])
            ->latest('issued_at')
            ->get()
            ->map(fn (Invoice $invoice) => $this->invoicePayload($invoice))
            ->values();

        return response()->json($invoices);
    }

    public function show(Request $request, Invoice $invoice): JsonResponse
    {
        $this->authorizeInvoice($request, $invoice);

        return response()->json(['invoice' => $this->invoicePayload($invoice)]);
    }

    public function pay(Request $request, Invoice $invoice): JsonResponse
    {
        $user = $request->user();

        abort_unless(
            $user->isOffice() && $invoice->order->office_id === $user->id,
            403,
            'Only the office that placed this order can settle its invoice.'
        );

        if ($invoice->status !== Invoice::STATUS_PAID) {
            $invoice->update([
                'status' => Invoice::STATUS_PAID,
                'paid_at' => now(),
            ]);
        }

        return response()->json(['invoice' => $this->invoicePayload($invoice->fresh())]);
    }

    private function authorizeInvoice(Request $request, Invoice $invoice): void
    {
        $user = $request->user();
        $invoice->loadMissing('order');

        $allowed = ($user->isMerchant() && $invoice->order->caterer_id === $user->id)
            || ($user->isOffice() && $invoice->order->office_id === $user->id);

        abort_unless($allowed, 403, 'You do not have access to this invoice.');
    }
}