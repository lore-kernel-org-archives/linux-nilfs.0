From: <Joachim.Henke-kyawv7ubMNaakBO8gow8eQ@public.gmane.org>
Subject: [PATCH] nilfs2: make splice write available again
Date: Sat, 23 Jan 2021 14:27:16 +0000
Message-ID: <FR2P281MB0283D8B316988BB9F697BF3BB2BF0@FR2P281MB0283.DEUP281.PROD.OUTLOOK.COM>
References: <YAwwjEuHpfeFDqNo@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=t-systems.com; i=@t-systems.com; q=dns/txt; s=mail;
  t=1611412755; x=1642948755;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r9Yy2Nt+b2nnEDqG3mFDIzNmoSgNWzVdxHU4e5rfr3g=;
  b=iMlwUQ3rgTZm9lt9wmIR0fFkP4X20OU0eXUK+BLheBfh6NAEZcyBuN4X
   ZW7G3s1owWxwIEaNt5Aii4+dLdEtY8BxcOM/obs5Otjkb8hQM7kpNoUuf
   Sfk4Tp5YmvvpNvORPsGvCph4cs6x+i2CJt8nSz40BkpBxH7o7I+5sNkPS
   H0eVjMJ2yhvAU7HyGR4+iNs5BcnPalDruD4FicYFLGSsxXioDeRyFTkVX
   eEu5ejSSVgw1m2BNevan6WCGHyyljVqaq7iWTAi+/svwXVlCCpcu6vr8U
   e+0J9Ueo+IWb8Hq5HabC4H7+y1Jqj59tJx0nBvUnqniVm7ZZ6Vxy2Ga/w
   Q==;
In-Reply-To: <YAwwjEuHpfeFDqNo-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Content-Language: de-DE
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Joachim.Henke-kyawv7ubMNaakBO8gow8eQ@public.gmane.org

U2luY2UgNS4xMCwgc3BsaWNlKCkgb3Igc2VuZGZpbGUoKSB0byBOSUxGUzIgcmV0dXJuIEVJTlZB
TC4gVGhpcyB3YXMNCnByb2JhYmx5IGNhdXNlZCBieSBjb21taXQgMzZlMmM3NDIxZjAyICgiZnM6
IGRvbid0IGFsbG93IHNwbGljZQ0KcmVhZC93cml0ZSB3aXRob3V0IGV4cGxpY2l0IG9wcyIpLg0K
DQpUaGlzIHBhdGNoIGluaXRpYWxpemVzIHRoZSBzcGxpY2Vfd3JpdGUgZmllbGQgaW4gZmlsZV9v
cGVyYXRpb25zLCBsaWtlDQptb3N0IGZpbGUgc3lzdGVtcyBkbywgdG8gcmVzdG9yZSB0aGUgZnVu
Y3Rpb25hbGl0eS4NCg0KU2lnbmVkLW9mZi1ieTogSm9hY2hpbSBIZW5rZSA8am9hY2hpbS5oZW5r
ZUB0LXN5c3RlbXMuY29tPg0KLS0tDQogZnMvbmlsZnMyL2ZpbGUuYyB8IDEgKw0KIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KDQpkaWZmIC0tZ2l0IGEvZnMvbmlsZnMyL2ZpbGUuYyBi
L2ZzL25pbGZzMi9maWxlLmMNCmluZGV4IDY0YmM4MTM2M2M2Y2MuLjRjN2E2NjIwNDc1MTMgMTAw
NjQ0DQotLS0gYS9mcy9uaWxmczIvZmlsZS5jDQorKysgYi9mcy9uaWxmczIvZmlsZS5jDQpAQCAt
MTQxLDYgKzE0MSw3IEBAIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgbmlsZnNfZmlsZV9v
cGVyYXRpb25zID0gew0KIAkvKiAucmVsZWFzZQk9IG5pbGZzX3JlbGVhc2VfZmlsZSwgKi8NCiAJ
LmZzeW5jCQk9IG5pbGZzX3N5bmNfZmlsZSwNCiAJLnNwbGljZV9yZWFkCT0gZ2VuZXJpY19maWxl
X3NwbGljZV9yZWFkLA0KKwkuc3BsaWNlX3dyaXRlCT0gaXRlcl9maWxlX3NwbGljZV93cml0ZSwN
CiB9Ow0KDQogY29uc3Qgc3RydWN0IGlub2RlX29wZXJhdGlvbnMgbmlsZnNfZmlsZV9pbm9kZV9v
cGVyYXRpb25zID0gew0K
