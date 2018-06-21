From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH] nilfs2: use 64-bit superblock timstamps
Date: Thu, 21 Jun 2018 11:41:26 +0900
Message-ID: <57ac1977-b060-77b1-61a5-8e7b690e162d@lab.ntt.co.jp>
References: <20180620075041.4154396-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20180620075041.4154396-1-arnd@arndb.de>
Content-Language: en-US
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: y2038@lists.linaro.org, David Howells <dhowells@redhat.com>, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>

T24gMjAxOC8wNi8yMCAxNjo1MCwgQXJuZCBCZXJnbWFubiB3cm90ZToKPiBUaGUgbW91bnQgdGlt
ZSBmaWVsZCBpbiB0aGUgc3VwZXJibG9jayB1c2VzIGEgNjQtYml0IHRpbWVzdGFtcCwgYnV0Cj4g
Y2FsbGluZyBnZXRfc2Vjb25kcygpIG1heSB0cnVuY2F0ZSB0aGUgY3VycmVudCB0aW1lIHRvIDMy
IGJpdHMuCj4gCj4gVGhpcyBjaGFuZ2VzIGl0IHRvIGt0aW1lX2dldF9yZWFsX3NlY29uZHMoKSB0
byBhdm9pZCB0aGUgcG90ZW50aWFsCj4gb3ZlcmZsb3cuCj4gCj4gU2lnbmVkLW9mZi1ieTogQXJu
ZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4KCkxvb2tzIGdvb2QgdG8gbWUuCgpUaGFua3MsIGFs
bC4KCkFja2VkLWJ5OiBSeXVzdWtlIEtvbmlzaGkgPGtvbmlzaGkucnl1c3VrZUBsYWIubnR0LmNv
LmpwPgoKCj4gLS0tCj4gICBmcy9uaWxmczIvc3VwZXIuYyB8IDIgKy0KPiAgIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQo+IAo+IGRpZmYgLS1naXQgYS9mcy9u
aWxmczIvc3VwZXIuYyBiL2ZzL25pbGZzMi9zdXBlci5jCj4gaW5kZXggNmZmZWNhODRkN2MzLi4x
YjkwNjdjZjQ1MTEgMTAwNjQ0Cj4gLS0tIGEvZnMvbmlsZnMyL3N1cGVyLmMKPiArKysgYi9mcy9u
aWxmczIvc3VwZXIuYwo+IEBAIC04MzQsNyArODM0LDcgQEAgc3RhdGljIGludCBuaWxmc19zZXR1
cF9zdXBlcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBpbnQgaXNfbW91bnQpCj4gICAJCXNicFsw
XS0+c19tYXhfbW50X2NvdW50ID0gY3B1X3RvX2xlMTYoTklMRlNfREZMX01BWF9NTlRfQ09VTlQp
Owo+ICAgCj4gICAJc2JwWzBdLT5zX21udF9jb3VudCA9IGNwdV90b19sZTE2KG1udF9jb3VudCAr
IDEpOwo+IC0Jc2JwWzBdLT5zX210aW1lID0gY3B1X3RvX2xlNjQoZ2V0X3NlY29uZHMoKSk7Cj4g
KwlzYnBbMF0tPnNfbXRpbWUgPSBjcHVfdG9fbGU2NChrdGltZV9nZXRfcmVhbF9zZWNvbmRzKCkp
Owo+ICAgCj4gICBza2lwX21vdW50X3NldHVwOgo+ICAgCXNicFswXS0+c19zdGF0ZSA9Cj4gCgoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFp
bGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3Jn
L21haWxtYW4vbGlzdGluZm8veTIwMzgK
