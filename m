From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 29/30] block: store the holder in
 file->private_data
Date: Fri, 9 Jun 2023 08:41:50 +0200
Message-ID: <8508b874-1ca3-be10-df95-074f80fd97da@suse.de>
References: <20230608110258.189493-1-hch@lst.de>
 <20230608110258.189493-30-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=7475krAAJYK/14IzgTvLBZhh/AiCmuFDFYhDk0jKLqc=; b=h/HPp7ADeYftYXgovMP8GVsVTD
 D73SnkgTAAmoCwdBbH/1sKleGL3uid61JV1U1WFZFt3EI1pGNQSENQcoAY84yatE3X3/PwE5mogDU
 XnbvkT1Yh7ihAGAZNrqXHaKpJfdNs6t8AWR9YiZfKHGfBT/3WH3M36lekUsOufLePDU8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
 Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=7475krAAJYK/14IzgTvLBZhh/AiCmuFDFYhDk0jKLqc=; b=NE59Ec3yLmUbpEwQqSDbH33Loi
 9XLvMDtapJd3L7JiGWIB+6OlI8HNwjY9m5k1tEmZoScywm5Qbkqo4EO2aaekpyUkAllJ9dPihK8H+
 UG3eTWbf7Py6hnhyszv9v1++n1Cm4m5GkDK580Z0JG0IQAfCb20IYNcTNTuNeyp3a+sY=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1686292912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7475krAAJYK/14IzgTvLBZhh/AiCmuFDFYhDk0jKLqc=;
 b=ZfOoInpx26P1yoO6fzBrxKp0D3D+W46qPqW9AU4AbDOdV+ELNCeSu7LNPvK0Oro/maPJFi
 T1bvdduZlCWkACYPx7rg3RHei8XZFfCkEvwhW0BzsqqrF3HolDyxfXy8kds4l1kcIhIbkr
 7/jMX5MorruWBa7EDgtVJ/WL6TYSK+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1686292912;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7475krAAJYK/14IzgTvLBZhh/AiCmuFDFYhDk0jKLqc=;
 b=2QztdtexZ+ss0ZxFr+Dm9aqdOMVriT9W8GZ6qRhUzIP0ZnEqqnNmToWbeakAuYQmq924rb
 KyuNig387/lbjtCg==
Content-Language: en-US
In-Reply-To: <20230608110258.189493-30-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.

T24gNi84LzIzIDEzOjAyLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBTdG9yZSB0aGUgZmls
ZSBzdHJ1Y3QgdXNlZCBhcyB0aGUgaG9sZGVyIGluIGZpbGUtPnByaXZhdGVfZGF0YSBhcyBhbgo+
IGluZGljYXRvciB0aGF0IHRoaXMgZmlsZSBkZXNjcmlwdG9yIHdhcyBvcGVuZWQgZXhjbHVzaXZl
bHkgdG8gIHJlbW92ZQo+IHRoZSBsYXN0IHVzZSBvZiBGTU9ERV9FWENMLgo+IAo+IFNpZ25lZC1v
ZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IC0tLQo+ICAgYmxvY2svZm9w
cy5jIHwgMTQgKysrKysrKystLS0tLS0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMo
KyksIDYgZGVsZXRpb25zKC0pCj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVA
c3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAg
ICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlv
bnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8
cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3RldiwgQW5kcmV3Ck15ZXJzLCBBbmRy
ZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJtYW4KCgoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtZjJmcy1kZXZlbCBtYWlsaW5nIGxp
c3QKTGludXgtZjJmcy1kZXZlbEBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQKaHR0cHM6Ly9saXN0cy5z
b3VyY2Vmb3JnZS5uZXQvbGlzdHMvbGlzdGluZm8vbGludXgtZjJmcy1kZXZlbAo=
