From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH 02/12] nilfs2: use setup_bdev_super to
 de-duplicate the mount code
Date: Fri, 4 Aug 2023 14:04:21 +0900
Message-ID: <CAKFNMok5+MeOWcRg6o8W0tKjW=dTupXdwyqivou+RydZP423fw@mail.gmail.com>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-3-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:Cc:To:
 Subject:Message-ID:Date:From:In-Reply-To:References:MIME-Version:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=gvHhQK58HED/Jid4BEU/8KSn5E/19+2WUDX2YX8J0Ko=; b=TB4dTl6VrcvD2xIAs/gtphIse+
 vcrwuR/E2DdqwGp+pheG8La953TS+ZxhRpwk1V7Cute1Lwi10v+DJwidVTqo3Q3xdBjmWvGVO7BE9
 mM/gHxqIoaAOThiz2BqwDR51z1U1VKOgoLVa37dR75by5ulV9leilneNR9b9PiXB90bQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:Cc:To:Subject:Message-ID:Date:From
 :In-Reply-To:References:MIME-Version:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=gvHhQK58HED/Jid4BEU/8KSn5E/19+2WUDX2YX8J0Ko=; b=OKTZiA8Sz2d6fME19IPSRbIM3S
 BPOnWdo9udYi/HuNpclSp/V+6eSyMwp7B/dtRcLDSptKJEkdJvuTqaYxZ31+eQhalR3raTu58yGVj
 FCajmCIoqwV26dyxFQqb1drNk1hNdHiADJKAJxekRmxMB/AOPvly9h6QGEW1mfCI3UjA=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1691125478; x=1691730278;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=gvHhQK58HED/Jid4BEU/8KSn5E/19+2WUDX2YX8J0Ko=;
 b=o9IkCnlJqf9fY5gy5fVwkiUJZ8iZ9Aas2C2/zh0DiHTx4LpNqcMZlkdMxITlOzTPD8
 2aRncGgbqPq91v/0LtcDvDi9gSK5UqbQjqaSIuz68NJB/TywdgsRaiusrFpo5ZDNJvM3
 5Q2bxAOzGs+xNKN49s1hCYbX+xnxEd8ZbVc1Jez05IsR8AxvQmPIBU6pIgVMqeIS/Olq
 ejkIH4vD76wZSX62Gg4NUPpx7pu+YIgWaArL5J1SZywhq143O42TygZ+nNZqRNUpyLEu
 qJ2IGSXe3NrAMJVgKZOHexBd+lqWhCoMuA0va/s2sFUTqGuRkjyQQthZd2zAjAwqTyny
 EDLg==
In-Reply-To: <20230802154131.2221419-3-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
Content-Type: text/plain; charset="windows-1252"
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, Jaegeuk Kim <jaegeuk@kernel.org>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

T24gVGh1LCBBdWcgMywgMjAyMyBhdCAxMjo0MeKAr0FNIENocmlzdG9waCBIZWxsd2lnIHdyb3Rl
Ogo+Cj4gVXNlIHRoZSBnZW5lcmljIHNldHVwX2JkZXZfc3VwZXIgaGVscGVyIHRvIG9wZW4gdGhl
IG1haW4gYmxvY2sgZGV2aWNlCj4gYW5kIGRvIHZhcmlvdXMgYml0cyBvZiBzdXBlcmJsb2NrIHNl
dHVwIGluc3RlYWQgb2YgZHVwbGljYXRpbmcgdGhlCj4gbG9naWMuICBUaGlzIGluY2x1ZGVzIG1v
dmluZyB0byB0aGUgbmV3IHNjaGVtZSBpbXBsZW1lbnRlZCBpbiBjb21tb24KPiBjb2RlIHRoYXQg
b25seSBvcGVucyB0aGUgYmxvY2sgZGV2aWNlIGFmdGVyIHRoZSBzdXBlcmJsb2NrIGhhcyBhbGxv
Y2F0ZWQuCj4KPiBJdCBkb2VzIG5vdCB5ZXQgY29udmVydCBuaWxmczIgdG8gdGhlIG5ldyBtb3Vu
dCBBUEksIGJ1dCBkb2luZyBzbyB3aWxsCj4gYmVjb21lIGEgYml0IHNpbXBsZXIgYWZ0ZXIgdGhp
cyBmaXJzdCBzdGVwLgo+Cj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+CgpBY2tlZC1ieTogUnl1c3VrZSBLb25pc2hpIDxrb25pc2hpLnJ5dXN1a2VAZ21haWwu
Y29tPgoKVGhpcyBwYXRjaCBpdHNlbGYgbG9va3MgdG8gcHJvcGVybHkgY29udmVydCBuaWxmc19t
b3VudCBldGMuICBUaGFuayB5b3Ugc28gbXVjaC4KClJlZ2FyZHMsClJ5dXN1a2UgS29uaXNoaQoK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LWYy
ZnMtZGV2ZWwgbWFpbGluZyBsaXN0CkxpbnV4LWYyZnMtZGV2ZWxAbGlzdHMuc291cmNlZm9yZ2Uu
bmV0Cmh0dHBzOi8vbGlzdHMuc291cmNlZm9yZ2UubmV0L2xpc3RzL2xpc3RpbmZvL2xpbnV4LWYy
ZnMtZGV2ZWwK
