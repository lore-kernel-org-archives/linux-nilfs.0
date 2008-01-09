From: "Jiwon Seo" <jiwon-FGKo4X94FMn2fBVCVOL8/A@public.gmane.org>
Subject: Question on porting nilfs back to linux 2.4.3
Date: Wed, 9 Jan 2008 11:13:19 -0800
Message-ID: <b008462b0801091113w620d9321p21de1d76f8dd3e8c@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
	bh=wct0PnojvQLuqJCi5+IrXWM8vxp+udmbd5n0pdQI1A4=;
	b=AbbqpBinySpDeNfQKKmgU6PA4su76zp/vUTcOg/UUyWe88MOlPqcOzgi4jFuVljxnHRAo7K7rDGxsTPlOel0u1Dq3BWw0CgVBQ5Tgcy2leSjQBLXxgten9DMO7cSB9wzpujN5IEEPXlRy/MuZB7//fouXBgjIqtx1KdZyfT8WVw=
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

For some reason, I might need to use nilfs on linux kernel version
2.4.3. Since quite significant work seems necessary to upgrade linux
version (it's running on a FPGA based system with much code depending
on linux kernel 2.4.3), I'm thinking of porting nilfs for 2.4.3

to compare the cost, I'd like to see your opinions on how difficult it
would be to port nilfs for linux 2.4.3. What parts are depending on
kernel 2.6, and how difficult do you think it is to change the part
for linux 2.4.3?

Thanks

Jiwon
