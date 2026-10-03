# Copyright IBM Corp. 2018, 2023
# SPDX-License-Identifier: MPL-2.0

FROM alpine:3.24.2
WORKDIR /app
ADD . /app
EXPOSE 9002
ENV PORT 9002
ENV COUNTING_SERVICE_URL http://localhost:9000
CMD ["./dashboard-service"]
