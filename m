From: "Sivan Toledo" <sivan.toledo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Physical block addresses?
Date: Mon, 28 Jan 2008 12:48:01 -0500
Message-ID: <196f72b10801280948uc9e1275o6c4bf1bf56cd26c2@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
	bh=HA6gnVfMkfaCFXoJiCzu2t8JplTXpYBMjdjgHeuk5lY=;
	b=GwYNWzbnqjRkfaxPUmRzdA9ZJChnctH0xzvtSPia/zc6jd6uXOuEetfdQfmqyDte4aIY3WeYvnDRCENdQwlCmypBgYpW0NxbnjH1JKy8jAR8OmNSQ0pFmkvhD+oQV8X54dJ74WlsxEpOeqtlvjKiUKBOK/DbNwd+NDUB3nxtoEo=
Content-Disposition: inline
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Content-Type: text/plain; charset="us-ascii"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

I am trying to figure out whether NILFS uses physical block addresses
as pointers in inodes and indirect blocks, but I could not figure this
out from the papers.

Does it? If so, I assume that when cleaning a segment and copying live
data to a new segment, each relocated block causes the propagation of
dirty blocks (because some other blocks point to the old segment, so
they need to be modified, and so on. Is that correct?

Thanks, Sivan Toledo
