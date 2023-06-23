From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 00/79] fs: new accessors for inode->i_ctime
Date: Fri, 23 Jun 2023 14:41:42 +0200
Message-ID: <20230623-wegelagerei-kanzlei-45cdcf5da157@brauner>
References: <20230621144507.55591-1-jlayton@kernel.org>
 <20230621152141.5961cf5f@gandalf.local.home>
 <2a5a069572b46b59dd16fe8d54e549a9b5bbb6eb.camel@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=WDuz/mF8fj+i+/ap56of24e8/R894BB1LybagVZ6DkM=; b=IGFW4LKIDX84jFwGcLWP++jyzA
 TgV0XGQp2SpTlp1KrgXKloEk2/5Kwdfa/erbgwmgvI8U+h8xWMpvHoBx6X7vbGvA35rvlFK7R66nN
 1uVQ322v9CUAruxOl3PMRQZlYyNdsUqPTB5pXlt4LhcPM5yA8wM03EY8u6c2a/Tu0RXc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=WDuz/mF8fj+i+/ap56of24e8/R894BB1LybagVZ6DkM=; b=SlxPL7mXevoV+pq7wCAc3m1ehy
 itmAfvBYXkephuSOsXubeTp3MFvoTVZER0knXBDJKsN6a9OW3slUygC43Xy3YezoDWltyf6I425hm
 TBXyqjUyKxex9qzioJWQ1A1jpApDB+FuUlwEwz+YCbypyh07qQ4nvX1oxwpoQ4l9T0I0=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1687524146;
 bh=ljQRDIRYG4TydFhjD0LuSn8BREerPmb4Ipkpa2QAq6Q=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=apfm6xvoeO6UvUfxPwNSOl0FaLWJ7ShkzzPeuSOb0bank70626+jFCCnlqxUCd2NX
 mV+Eb3SlbyeKtShM0cPnGoccCVrProiQPYgaM4HyeW5epsbNbu8US+O9nrIP4r+ghW
 Y8FmG2CVOdPNZ1eNovI71PsOzsGS/p5EOkEcjtA4zTWfFdhpQkNKBq1hEMuzxsWytK
 w9zTBeB4xmhiyjllhLtRaoNC8lgBTTH19xNIsLsgb+18yFVUlxxLoSku7XQ5A1i1lR
 WF4IRekFC21BVGIj1AxyqNGVCxMph3jwY74VjiaGchsSc5v31PlBNGYvRkbk2aFmu+
 9KQZIm3JpdS0g==
Content-Disposition: inline
In-Reply-To: <2a5a069572b46b59dd16fe8d54e549a9b5bbb6eb.camel@kernel.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
Content-Type: text/plain; charset="iso-8859-1"
To: Jeff Layton <jlayton@kernel.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, "Rafael J. Wysocki" <rafael@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Anders Larsen <al@alarsen.net>, Carlos Llamas <cmllamas@google.com>, Andrii Nakryiko <andrii@kernel.org>, Hugh Dickins <hughd@google.com>, John Johansen <john.johansen@canonical.com>, Seth Forshee <sforshee@digitalocean.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christoph Hellwig <hch@lst.de>, Mike Marshall <hubcap@omnibond.com>, Paulo Alcantara <pc@manguebit.com>, linux-xfs@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Michael Ellerman <mpe@ellerman.id.au>, John Keeping <john@keeping.me.uk>, Zhang Yi <yi.zhang@huawei.com>, James Morris <jmorris@namei.org>, Christophe Leroy <christophe.leroy@csgroup.eu>, Tyler Hicks <code@tyhicks.com>, Alan Stern <stern@rowland.harvard.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, devel@lists.ora

T24gV2VkLCBKdW4gMjEsIDIwMjMgYXQgMDM6NTI6MjdQTSAtMDQwMCwgSmVmZiBMYXl0b24gd3Jv
dGU6Cj4gT24gV2VkLCAyMDIzLTA2LTIxIGF0IDE1OjIxIC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3
cm90ZToKPiA+IE9uIFdlZCwgMjEgSnVuIDIwMjMgMTA6NDU6MDUgLTA0MDAKPiA+IEplZmYgTGF5
dG9uIDxqbGF5dG9uQGtlcm5lbC5vcmc+IHdyb3RlOgo+ID4gCj4gPiA+IE1vc3Qgb2YgdGhpcyBj
b252ZXJzaW9uIHdhcyBkb25lIHZpYSBjb2NjaW5lbGxlLCB3aXRoIGEgZmV3IG9mIHRoZSBtb3Jl
Cj4gPiA+IG5vbi1zdGFuZGFyZCBhY2Nlc3NlcyBkb25lIGJ5IGhhbmQuIFRoZXJlIHNob3VsZCBi
ZSBubyBiZWhhdmlvcmFsCj4gPiA+IGNoYW5nZXMgd2l0aCB0aGlzIHNldC4gVGhhdCB3aWxsIGNv
bWUgbGF0ZXIsIGFzIHdlIGNvbnZlcnQgaW5kaXZpZHVhbAo+ID4gPiBmaWxlc3lzdGVtcyB0byB1
c2UgbXVsdGlncmFpbiB0aW1lc3RhbXBzLgo+ID4gCj4gPiBCVFcsIExpbnVzIGhhcyBzdWdnZXN0
ZWQgdG8gbWUgdGhhdCB3aGVuZXZlciBhIGNvbmNjaW5lbGxlIHNjcmlwdCBpcyB1c2VkLAo+ID4g
aXQgc2hvdWxkIGJlIGluY2x1ZGVkIGluIHRoZSBjaGFuZ2UgbG9nLgo+ID4gCj4gCj4gT2ssIGhl
cmUncyB3aGF0IEkgaGF2ZS4gSSBub3RlIGFnYWluIHRoYXQgbXkgdXNhZ2Ugb2YgY29jY2luZWxs
ZSBpcwo+IHByZXR0eSBwcmltaXRpdmUsIHNvIEkgZW5kZWQgdXAgZG9pbmcgYSBmYWlyIGJpdCBv
ZiBieS1oYW5kIGZpeGluZyBhZnRlcgo+IGFwcGx5aW5nIHRoZXNlLgo+IAo+IEdpdmVuIHRoZSB3
YXkgdGhhdCB0aGlzIGNoYW5nZSBpcyBicm9rZW4gdXAgaW50byA3NyBwYXRjaGVzIGJ5Cj4gc3Vi
c3lzdGVtLCB0byB3aGljaCBjaGFuZ2Vsb2dzIHNob3VsZCBJIGFkZCBpdD8gSSBjb3VsZCBhZGQg
aXQgdG8gdGhlCj4gImluZnJhc3RydWN0dXJlIiBwYXRjaCwgYnV0IHRoYXQncyB0aGUgb25lIHdo
ZXJlIEkgX2RpZG4ndF8gdXNlIGl0LsKgCj4gCj4gTWF5YmUgdG8gcGF0Y2ggIzc5ICh0aGUgb25l
IHRoYXQgcmVuYW1lcyBpX2N0aW1lKT8KClRoYXQgd29ya3MuIEkgY2FuIGFsc28gcHV0IHRoaXMg
aW50byBhIG1lcmdlIGNvbW1pdCBvciBwciBtZXNzYWdlLgoKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LWYyZnMtZGV2ZWwgbWFpbGluZyBsaXN0
CkxpbnV4LWYyZnMtZGV2ZWxAbGlzdHMuc291cmNlZm9yZ2UubmV0Cmh0dHBzOi8vbGlzdHMuc291
cmNlZm9yZ2UubmV0L2xpc3RzL2xpc3RpbmZvL2xpbnV4LWYyZnMtZGV2ZWwK
