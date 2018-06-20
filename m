From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] nilfs2: use 64-bit superblock timstamps
Date: Wed, 20 Jun 2018 09:50:26 +0200
Message-ID: <20180620075041.4154396-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
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
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Jeff Layton <jlayton@redhat.com>, y2038@lists.linaro.org, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>

VGhlIG1vdW50IHRpbWUgZmllbGQgaW4gdGhlIHN1cGVyYmxvY2sgdXNlcyBhIDY0LWJpdCB0aW1l
c3RhbXAsIGJ1dApjYWxsaW5nIGdldF9zZWNvbmRzKCkgbWF5IHRydW5jYXRlIHRoZSBjdXJyZW50
IHRpbWUgdG8gMzIgYml0cy4KClRoaXMgY2hhbmdlcyBpdCB0byBrdGltZV9nZXRfcmVhbF9zZWNv
bmRzKCkgdG8gYXZvaWQgdGhlIHBvdGVudGlhbApvdmVyZmxvdy4KClNpZ25lZC1vZmYtYnk6IEFy
bmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+Ci0tLQogZnMvbmlsZnMyL3N1cGVyLmMgfCAyICst
CiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1n
aXQgYS9mcy9uaWxmczIvc3VwZXIuYyBiL2ZzL25pbGZzMi9zdXBlci5jCmluZGV4IDZmZmVjYTg0
ZDdjMy4uMWI5MDY3Y2Y0NTExIDEwMDY0NAotLS0gYS9mcy9uaWxmczIvc3VwZXIuYworKysgYi9m
cy9uaWxmczIvc3VwZXIuYwpAQCAtODM0LDcgKzgzNCw3IEBAIHN0YXRpYyBpbnQgbmlsZnNfc2V0
dXBfc3VwZXIoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgaW50IGlzX21vdW50KQogCQlzYnBbMF0t
PnNfbWF4X21udF9jb3VudCA9IGNwdV90b19sZTE2KE5JTEZTX0RGTF9NQVhfTU5UX0NPVU5UKTsK
IAogCXNicFswXS0+c19tbnRfY291bnQgPSBjcHVfdG9fbGUxNihtbnRfY291bnQgKyAxKTsKLQlz
YnBbMF0tPnNfbXRpbWUgPSBjcHVfdG9fbGU2NChnZXRfc2Vjb25kcygpKTsKKwlzYnBbMF0tPnNf
bXRpbWUgPSBjcHVfdG9fbGU2NChrdGltZV9nZXRfcmVhbF9zZWNvbmRzKCkpOwogCiBza2lwX21v
dW50X3NldHVwOgogCXNicFswXS0+c19zdGF0ZSA9Ci0tIAoyLjkuMAoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4
QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGlu
Zm8veTIwMzgK
