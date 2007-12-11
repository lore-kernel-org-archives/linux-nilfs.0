From: "Sivan Toledo" <sivan.toledo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: A question about segment sizes and alignment
Date: Tue, 11 Dec 2007 13:59:58 -0500
Message-ID: <196f72b10712111059m2e813aa4ga02ce5ccef4ae1ba@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
	bh=HeLJA20yMcUTzYV1ZGhbIlxEZytcstx606pkLVgANJk=;
	b=jus0nmljFIVfiJoWq8iXWv0+0XffLfK4LupWySBQi8ErRtq4CQbNviWoV2j7sLORLbwWuKLCo0mF+jpE5SWABlLMZ1NXWx/Eb0Y9hggKssaxro9Ta4eA5nc+71Xj8rgyRLHLErFqvuPL533FyzFknI3t1nEy+MSWPnanPGeIO30=
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

I have a few questions that I have not been able to figure out from
reading the NILFS papers and from a quick look at the code.

What is the segment size that NILFS uses?
Is it possible to tune the segment size, perhaps by changing constants
in .h files?
Are the segments aligned in the address space of the block device?
That is, if each segment is 1MB, say, do the first one start in
address 0 of the block device, the second in address 2^20, the third
in address 2*2^20, the fourth in 3*2^20, and so on, or are they
misaligned because of the superblock and the segment usage chunks, so
they don't always start on a 1MB boundary.

Thanks, Sivan Toledo
