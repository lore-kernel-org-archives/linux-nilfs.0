From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 01/32] block: Provide blkdev_get_handle_*
	functions
Date: Mon, 31 Jul 2023 12:50:34 +0200
Message-ID: <20230731105034.43skhi5ubze563c3@quack3>
References: <20230629165206.383-1-jack@suse.cz>
	<20230704122224.16257-1-jack@suse.cz>
	<ZKbgAG5OoHVyUKOG@infradead.org>
	<CAJpMwyiUcw+mH0sZa8f8UJsaSZ7NSE65s2gZDEia+pASyP_gJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1690800635;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=PJDu3H9G0xjlLFp1Wxvq9yQHkB2Q9jBIbPsGkP5jLhY=;
	b=LfsIvVgX25rf01P6sVcmZRL3nPMT3sPJRPMrpOspwMqpMg9mmQx6AkDi/eF6WU32a2Vp6x
	/7YLD1OJK0u+bqfGa4P87gaOpA6/QZlHA1eZkenSQs1V9CjuRPICqxTQ9KdHYFZ84hOqsV
	4L46K3Rf4+bEtg2brIa/aboXrQrqviE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1690800635;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=PJDu3H9G0xjlLFp1Wxvq9yQHkB2Q9jBIbPsGkP5jLhY=;
	b=X5g/KyOpcE2CiMGegP9N6Ypxz5sWUyAuayNnMILk5q3XabEg0BuGZ7c8jHqKycooaqKD7s
	Ajq9KEorZZBfWcDQ==
Content-Disposition: inline
In-Reply-To: <CAJpMwyiUcw+mH0sZa8f8UJsaSZ7NSE65s2gZDEia+pASyP_gJQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Content-Type: text/plain; charset="windows-1252"
To: Haris Iqbal <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>
Cc: Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, Gao Xiang <xiang-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Borntraeger <borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sven Schnelle <svens-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Snitzer <snitzer-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joern Engel <joern-o6zPIXG8fmPj4SYmN/TMmA@public.gmane.org>, re

T24gV2VkIDEyLTA3LTIzIDE4OjA2OjM1LCBIYXJpcyBJcWJhbCB3cm90ZToKPiBPbiBUaHUsIEp1
bCA2LCAyMDIzIGF0IDU6MzjigK9QTSBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5v
cmc+IHdyb3RlOgo+ID4KPiA+IE9uIFR1ZSwgSnVsIDA0LCAyMDIzIGF0IDAyOjIxOjI4UE0gKzAy
MDAsIEphbiBLYXJhIHdyb3RlOgo+ID4gPiBDcmVhdGUgc3RydWN0IGJkZXZfaGFuZGxlIHRoYXQg
Y29udGFpbnMgYWxsIHBhcmFtZXRlcnMgdGhhdCBuZWVkIHRvIGJlCj4gPiA+IHBhc3NlZCB0byBi
bGtkZXZfcHV0KCkgYW5kIHByb3ZpZGUgYmxrZGV2X2dldF9oYW5kbGVfKiBmdW5jdGlvbnMgdGhh
dAo+ID4gPiByZXR1cm4gdGhpcyBzdHJ1Y3R1cmUgaW5zdGVhZCBvZiBwbGFpbiBiZGV2IHBvaW50
ZXIuIFRoaXMgd2lsbAo+ID4gPiBldmVudHVhbGx5IGFsbG93IHVzIHRvIHBhc3Mgb25lIG1vcmUg
YXJndW1lbnQgdG8gYmxrZGV2X3B1dCgpIHdpdGhvdXQKPiA+ID4gdG9vIG11Y2ggaGFzc2xlLgo+
ID4KPiA+IENhbiB3ZSB1c2UgdGhlIG9wcG9ydHVuaXR5IHRvIGNvbWUgdXAgd2l0aCBiZXR0ZXIg
bmFtZXM/ICBibGtkZXZfZ2V0XyoKPiA+IHdhcyBhbHdheXMgYSByYXRoZXIgaG9ycmlibGUgbmFt
aW5nIGNvbnZlbnRpb24gZm9yIHNvbWV0aGluZyB0aGF0Cj4gPiBlbmRzIHVwIGNhbGxpbmcgaW50
byAtPm9wZW4uCj4gPgo+ID4gV2hhdCBhYm91dDoKPiA+Cj4gPiBzdHJ1Y3QgYmRldl9oYW5kbGUg
KmJkZXZfb3Blbl9ieV9kZXYoZGV2X3QgZGV2LCBibGtfbW9kZV90IG1vZGUsIHZvaWQgKmhvbGRl
ciwKPiA+ICAgICAgICAgICAgICAgICBjb25zdCBzdHJ1Y3QgYmxrX2hvbGRlcl9vcHMgKmhvcHMp
Owo+ID4gc3RydWN0IGJkZXZfaGFuZGxlICpiZGV2X29wZW5fYnlfcGF0aChkZXZfdCBkZXYsIGJs
a19tb2RlX3QgbW9kZSwKPiA+ICAgICAgICAgICAgICAgICB2b2lkICpob2xkZXIsIGNvbnN0IHN0
cnVjdCBibGtfaG9sZGVyX29wcyAqaG9wcyk7Cj4gPiB2b2lkIGJkZXZfcmVsZWFzZShzdHJ1Y3Qg
YmRldl9oYW5kbGUgKmhhbmRsZSk7Cj4gCj4gKzEgdG8gdGhpcy4KPiBBbHNvLCBpZiB3ZSBhcmUg
cmVtb3ZpbmcgImhhbmRsZSIgZnJvbSB0aGUgZnVuY3Rpb24sIHNob3VsZCB0aGUgbmFtZQo+IG9m
IHRoZSBzdHJ1Y3R1cmUgaXQgcmV0dXJucyBhbHNvIGNoYW5nZT8gV291bGQgc29tZXRoaW5nIGxp
a2UgYmRldl9jdHgKPiBiZSBiZXR0ZXI/CgpJIHRoaW5rIHRoZSBiZGV2X2hhbmRsZSBuYW1lIGlz
IGZpbmUgZm9yIHRoZSBzdHJ1Y3QuIEFmdGVyIGFsbCBpdCBpcwplcXVpdmFsZW50IG9mIGFuIG9w
ZW4gaGFuZGxlIGZvciB0aGUgYmxvY2sgZGV2aWNlIHNvIElNSE8gYmRldl9oYW5kbGUKY2FwdHVy
ZXMgdGhhdCBiZXR0ZXIgdGhhbiBiZGV2X2N0eC4KCgkJCQkJCQkJSG9uemEKLS0gCkphbiBLYXJh
IDxqYWNrQHN1c2UuY29tPgpTVVNFIExhYnMsIENSCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmRyYmQtZGV2IG1haWxpbmcgbGlzdApkcmJkLWRldkBsaXN0
cy5saW5iaXQuY29tCmh0dHBzOi8vbGlzdHMubGluYml0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Ry
YmQtZGV2Cg==
