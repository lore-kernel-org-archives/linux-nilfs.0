From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/30] cdrom: track if a cdrom_device_info
 was opened for data
Date: Fri, 9 Jun 2023 08:37:38 +0200
Message-ID: <f398627e-f69f-de42-d55d-2d497d208ae5@suse.de>
References: <20230608110258.189493-1-hch@lst.de>
 <20230608110258.189493-6-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686292673;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3tiQLrUQaD6qaZz9Qj/U8SyopOtKSSxx/RaRZl9zl54=;
	b=N16hqFxZ7eIgWuDAp6fxyIQYr799lRQnXkmS2NPbRPspcjzcOfZVQW9JDojwJ7mPTEckxJ
	ryR8UKo2KIG/aSzHKwK1P/ia2FVwvyCGxzBQm0lgrAdEVWj+Jh2Hj2kL/5LNHADz4yiAw7
	9+TqTRBm2yX3Q1/eO5ELrM2wtosB0PM=
In-Reply-To: <20230608110258.189493-6-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.

T24gNi84LzIzIDEzOjAyLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBTZXQgYSBmbGFnIHdo
ZW4gYSBjZHJvbV9kZXZpY2VfaW5mbyBpcyBvcGVuZWQgZm9yIHdyaXRpbmcsIGluc3RlYWQgb2YK
PiB0cnlpbmcgdG8gZmlndXJlIG91dCB0aGlzIGF0IHJlbGVhc2UgdGltZS4gIFRoaXMgd2lsbCBh
bGxvdyB0byBldmVudHVhbGx5Cj4gcmVtb3ZlIHRoZSBtb2RlIGFyZ3VtZW50IHRvIHRoZSAtPnJl
bGVhc2UgYmxvY2tfZGV2aWNlX29wZXJhdGlvbiBhcwo+IG5vdGhpbmcgYnV0IHRoZSBDRFJPTSBk
cml2ZXJzIHVzZXMgdGhhdCBhcmd1bWVudC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGgg
SGVsbHdpZyA8aGNoQGxzdC5kZT4KPiBSZXZpZXdlZC1ieTogUGhpbGxpcCBQb3R0ZXIgPHBoaWxA
cGhpbHBvdHRlci5jby51az4KPiBBY2tlZC1ieTogQ2hyaXN0aWFuIEJyYXVuZXIgPGJyYXVuZXJA
a2VybmVsLm9yZz4KPiAtLS0KPiAgIGRyaXZlcnMvY2Ryb20vY2Ryb20uYyB8IDEyICsrKysrLS0t
LS0tLQo+ICAgaW5jbHVkZS9saW51eC9jZHJvbS5oIHwgIDEgKwo+ICAgMiBmaWxlcyBjaGFuZ2Vk
LCA2IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCj4gClJldmlld2VkLWJ5OiBIYW5uZXMg
UmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBS
ZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNl
LmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBT
b2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhS
QiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3RldiwgQW5k
cmV3Ck15ZXJzLCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJtYW4KCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

